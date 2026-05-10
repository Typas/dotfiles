#!/usr/bin/env bash
set -euo pipefail

# Inputs (env):
#   HEAD_REF  PR head branch name
#   BASE_SHA  base commit
#   HEAD_SHA  head commit
# Optional override for local dry-run:
#   BR_POLICY_FILES_OVERRIDE  newline-separated file list; skips git diff

branch="$HEAD_REF"
echo "Branch: $branch"

if [[ -n "${BR_POLICY_FILES_OVERRIDE:-}" ]]; then
    mapfile -t files <<< "$BR_POLICY_FILES_OVERRIDE"
else
    mapfile -t files < <(git diff --name-only "$BASE_SHA" "$HEAD_SHA")
fi
printf 'Changed files:\n'
printf '  %s\n' "${files[@]}"

is_doc() { [[ "$1" == *.md || "$1" == *.org ]]; }
is_ci()  { [[ "$1" == .github/* ]]; }
is_shared_bootstrap() {
    [[ "$1" == init.sh || "$1" == scripts/shell-init.sh || "$1" == justfile ]]
}
is_mac_bootstrap() {
    [[ "$1" == flake.nix || "$1" == flake.lock \
       || "$1" == nix/* || "$1" == hosts/* \
       || "$1" == .github/actions/mac-nix-setup/* ]]
}
is_linux_container_setup() {
    [[ "$1" == .github/actions/linux-container-setup/* ]]
}

list_public_recipes() {
    awk '
        /^alias[[:space:]]+[a-zA-Z][a-zA-Z0-9_-]*[[:space:]]*:=/ { print $2; next }
        /^[a-zA-Z][a-zA-Z0-9_-]*[[:space:]]*:=/ { next }
        /^[a-zA-Z][a-zA-Z0-9_-]*([[:space:]][a-zA-Z0-9_=" -]*)?:/ {
            sub(":.*$", "", $0); sub("[[:space:]].*$", "", $0); print
        }
    ' justfile
}

case "$branch" in
    docs/*)
        for f in "${files[@]}"; do
            if ! is_doc "$f"; then
                echo "docs/ branch must only touch *.md or *.org: $f" >&2
                exit 1
            fi
        done
        ;;
    ci/*)
        for f in "${files[@]}"; do
            if ! is_ci "$f" && ! is_doc "$f"; then
                echo "ci/ branch must only touch .github/ or *.md/*.org: $f" >&2
                exit 1
            fi
        done
        ;;
    bootstrap/shared)
        for f in "${files[@]}"; do
            if ! is_shared_bootstrap "$f" && ! is_doc "$f"; then
                echo "bootstrap/shared must only touch init.sh, scripts/shell-init.sh, justfile, or *.md/*.org: $f" >&2
                exit 1
            fi
        done
        ;;
    bootstrap/mac)
        for f in "${files[@]}"; do
            if ! is_mac_bootstrap "$f" && ! is_doc "$f"; then
                echo "bootstrap/mac must only touch flake.nix, flake.lock, nix/**, hosts/**, .github/actions/mac-nix-setup/**, or *.md/*.org: $f" >&2
                exit 1
            fi
        done
        ;;
    bootstrap/*)
        distro="${branch#bootstrap/}"
        for f in "${files[@]}"; do
            if [[ "$f" != "os-init/${distro}-init.sh" ]] && ! is_linux_container_setup "$f" && ! is_doc "$f"; then
                echo "bootstrap/${distro} must only touch os-init/${distro}-init.sh, .github/actions/linux-container-setup/**, or *.md/*.org: $f" >&2
                exit 1
            fi
        done
        ;;
    dev/*)
        recipe="${branch#dev/}"
        mapfile -t public_recipes < <(list_public_recipes)
        match=0
        for r in "${public_recipes[@]}"; do
            if [[ "$r" == "$recipe" ]]; then
                match=1
                break
            fi
        done
        if (( match == 0 )); then
            echo "dev/<name> must match a public recipe in justfile: '$recipe' not found" >&2
            printf '  available: %s\n' "${public_recipes[@]}" >&2
            exit 1
        fi
        for f in "${files[@]}"; do
            if is_shared_bootstrap "$f" || is_mac_bootstrap "$f" \
               || is_linux_container_setup "$f" || [[ "$f" == os-init/* ]]; then
                echo "dev/$recipe cannot touch bootstrap-scope file: $f" >&2
                exit 1
            fi
        done
        ;;
    unsafe/*)
        ;;
    *)
        echo "branch '$branch' does not match an allowed prefix (docs/, ci/, bootstrap/, dev/, unsafe/)" >&2
        exit 1
        ;;
esac
echo "scope OK"
