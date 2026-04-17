#!/usr/bin/env bash
# Shared parallel runner with live-streamed, prefixed output
# Source this file, then use run_parallel/wait_parallel

_PP_PIDS=()
_PP_TMPDIR=""
_PP_LOCKFILE=""
_PP_LASTFILE=""

_pp_init() {
    if [ -z "$_PP_TMPDIR" ]; then
        _PP_TMPDIR=$(mktemp -d)
        _PP_LOCKFILE="$_PP_TMPDIR/.lock"
        _PP_LASTFILE="$_PP_TMPDIR/.last"
        trap 'rm -rf "$_PP_TMPDIR"' EXIT
    fi
}

_pp_prefix_output() {
    local label="$1"
    # +2 for the brackets, +1 for the space after
    local pad
    pad=$(printf '%*s' "$((${#label} + 3))" '')

    while IFS= read -r line; do
        (
            flock 9
            local last
            last=$(cat "$_PP_LASTFILE" 2>/dev/null || echo "")
            if [ "$last" = "$label" ]; then
                printf '%s%s\n' "$pad" "$line"
            else
                printf '[%s] %s\n' "$label" "$line"
                printf '%s' "$label" > "$_PP_LASTFILE"
            fi
        ) 9>"$_PP_LOCKFILE"
    done
}

run_parallel() {
    local label="$1"
    shift
    _pp_init

    "$@" 2>&1 | _pp_prefix_output "$label" &
    _PP_PIDS+=("$!")
}

wait_parallel() {
    local failures=0
    for pid in "${_PP_PIDS[@]}"; do
        if ! wait "$pid" 2>/dev/null; then
            ((failures++)) || true
        fi
    done
    return "$failures"
}
