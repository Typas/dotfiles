#!/usr/bin/env bash
set -euo pipefail

# Inputs (env):
#   HEAD_REF  PR head branch name
#   HEAD_SHA  head commit
#   GH_TOKEN  GitHub token (for gh CLI)
#   REPO      owner/name slug

branch="$HEAD_REF"
case "$branch" in
    docs/*)                required="" ;;
    ci/*|bootstrap/shared) required="bootstrap" ;;
    bootstrap/*)           required="distro" ;;
    dev/*)                 required="recipe" ;;
    unsafe/*)              required="bootstrap" ;;
    *) echo "unexpected branch '$branch'" >&2; exit 1 ;;
esac

if [[ -z "$required" ]]; then
    echo "No workflow required for $branch"
    exit 0
fi

echo "Waiting for workflow '$required' on $HEAD_SHA"
deadline=$(( $(date +%s) + 3600 ))
while :; do
    run_json=$(gh api "repos/$REPO/actions/runs?head_sha=$HEAD_SHA&per_page=100" \
        --jq "[.workflow_runs[] | select(.name==\"$required\")] | first")
    if [[ -z "$run_json" || "$run_json" == "null" ]]; then
        echo "no '$required' run yet for $HEAD_SHA; waiting..."
    else
        status=$(echo "$run_json" | jq -r .status)
        conclusion=$(echo "$run_json" | jq -r .conclusion)
        echo "status=$status conclusion=$conclusion"
        if [[ "$status" == "completed" ]]; then
            if [[ "$conclusion" != "success" ]]; then
                echo "'$required' ended with '$conclusion'" >&2
                exit 1
            fi
            echo "'$required' succeeded"
            exit 0
        fi
    fi
    if (( $(date +%s) > deadline )); then
        echo "timed out waiting for '$required'" >&2
        exit 1
    fi
    sleep 20
done
