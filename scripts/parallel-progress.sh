#!/usr/bin/env bash
# Shared parallel runner with prefixed output
# Source this file, then use run_parallel/wait_parallel

_PP_NAMES=()
_PP_PIDS=()
_PP_LOGS=()
_PP_OFFSETS=()
_PP_TMPDIR=""
_PP_LAST=""

run_parallel() {
    local label="$1"
    shift

    if [ -z "$_PP_TMPDIR" ]; then
        _PP_TMPDIR=$(mktemp -d)
        trap 'rm -rf "$_PP_TMPDIR"' EXIT
    fi

    local logfile="$_PP_TMPDIR/${#_PP_NAMES[@]}.log"
    : > "$logfile"
    "$@" 2>&1 | while IFS= read -r line; do echo "$line" >> "$logfile"; done &

    _PP_NAMES+=("$label")
    _PP_PIDS+=("$!")
    _PP_LOGS+=("$logfile")
    _PP_OFFSETS+=(0)
}

_pp_flush() {
    local num=${#_PP_NAMES[@]}
    for i in $(seq 0 $((num - 1))); do
        local total
        total=$(wc -l < "${_PP_LOGS[$i]}")
        if [ "$total" -gt "${_PP_OFFSETS[$i]}" ]; then
            local name="${_PP_NAMES[$i]}"
            local pad
            pad=$(printf '%*s' "$((${#name} + 3))" '')
            while IFS= read -r line; do
                if [ "$_PP_LAST" = "$name" ]; then
                    printf '%s%s\n' "$pad" "$line"
                else
                    printf '[%s] %s\n' "$name" "$line"
                    _PP_LAST="$name"
                fi
            done < <(tail -n "+$((_PP_OFFSETS[$i] + 1))" "${_PP_LOGS[$i]}")
            _PP_OFFSETS[$i]=$total
        fi
    done
}

wait_parallel() {
    local failures=0

    while true; do
        local all_done=true
        for pid in "${_PP_PIDS[@]}"; do
            kill -0 "$pid" 2>/dev/null && all_done=false
        done

        _pp_flush

        if $all_done; then
            _pp_flush
            break
        fi
        sleep 0.1
    done

    for pid in "${_PP_PIDS[@]}"; do
        wait "$pid" 2>/dev/null || ((failures++)) || true
    done
    return "$failures"
}
