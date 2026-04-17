#!/usr/bin/env bash
# Shared buildx-style parallel progress display
# Source this file, then use run_parallel/wait_parallel

_PP_NAMES=()
_PP_PIDS=()
_PP_LOGS=()
_PP_TMPDIR=""
_PP_FIRST_DRAW=true
_PP_SPINNER=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')

_pp_cleanup() {
    if [ -n "$_PP_TMPDIR" ] && [ -d "$_PP_TMPDIR" ]; then
        rm -rf "$_PP_TMPDIR"
    fi
}

run_parallel() {
    local label="$1"
    shift

    if [ -z "$_PP_TMPDIR" ]; then
        _PP_TMPDIR=$(mktemp -d)
        trap '_pp_cleanup' EXIT
    fi

    local logfile="$_PP_TMPDIR/${label// /_}.log"
    "$@" > "$logfile" 2>&1 &
    local pid=$!

    _PP_NAMES+=("$label")
    _PP_PIDS+=("$pid")
    _PP_LOGS+=("$logfile")
}

wait_parallel() {
    local num=${#_PP_NAMES[@]}
    if [ "$num" -eq 0 ]; then return 0; fi

    # non-TTY fallback: wait sequentially with simple output
    if [ ! -t 1 ]; then
        local failures=0
        for i in $(seq 0 $((num - 1))); do
            if wait "${_PP_PIDS[$i]}" 2>/dev/null; then
                echo "✔ ${_PP_NAMES[$i]}: done"
            else
                echo "✘ ${_PP_NAMES[$i]}: FAILED"
                ((failures++)) || true
            fi
        done
        return "$failures"
    fi

    local -a status
    local -a exit_codes
    for i in $(seq 0 $((num - 1))); do
        status[i]="running"
        exit_codes[i]=""
    done

    local spin_idx=0
    local failures=0

    while true; do
        local all_done=true

        # check each process
        for i in $(seq 0 $((num - 1))); do
            if [ "${status[$i]}" = "running" ]; then
                if ! kill -0 "${_PP_PIDS[$i]}" 2>/dev/null; then
                    wait "${_PP_PIDS[$i]}" 2>/dev/null
                    exit_codes[i]=$?
                    if [ "${exit_codes[i]}" -eq 0 ]; then
                        status[i]="done"
                    else
                        status[i]="failed"
                        ((failures++)) || true
                    fi
                else
                    all_done=false
                fi
            fi
        done

        # move cursor up if not first draw
        if [ "$_PP_FIRST_DRAW" = false ]; then
            printf '\033[%dA' "$num"
        fi
        _PP_FIRST_DRAW=false

        # draw each line
        local spinner="${_PP_SPINNER[$((spin_idx % ${#_PP_SPINNER[@]}))]}"
        for i in $(seq 0 $((num - 1))); do
            local last_line
            last_line=$(tail -1 "${_PP_LOGS[$i]}" 2>/dev/null || echo "")
            # truncate to fit terminal
            local max_width
            max_width=$(( $(tput cols 2>/dev/null || echo 80) - 1 ))

            case "${status[$i]}" in
                running)
                    local line=" $spinner ${_PP_NAMES[$i]}: ${last_line:-starting...}"
                    printf '\033[K%s\n' "${line:0:$max_width}"
                    ;;
                done)
                    local line=" ✔ ${_PP_NAMES[$i]}: done"
                    printf '\033[K%s\n' "${line:0:$max_width}"
                    ;;
                failed)
                    local line=" ✘ ${_PP_NAMES[$i]}: FAILED (exit ${exit_codes[$i]})"
                    printf '\033[K%s\n' "${line:0:$max_width}"
                    ;;
            esac
        done

        if $all_done; then break; fi
        spin_idx=$((spin_idx + 1))
        sleep 0.2
    done

    return "$failures"
}
