#!/usr/bin/env bash
set -euo pipefail

# Inputs (env):
#   RECIPE - recipe name (from setup parse step)
#
# Compares the branch against origin/master (three-dot) and emits a JSON
# array of matrix include entries for the CI targets actually affected.
# Merging master into the branch is a no-op for classification because the
# merge-base advances with master.

: "${RECIPE:?RECIPE required}"

ALL_TARGETS=(ubuntu mac debian-trixie fedora-43 fedora-44 opensuse-tumbleweed cachyos)

declare -A TARGET_JSON=(
    [ubuntu]='{"name":"ubuntu","kind":"ubuntu","runs-on":"ubuntu-24.04","container":"","pkg":""}'
    [mac]='{"name":"mac","kind":"mac","runs-on":"macos-26","container":"","pkg":""}'
    [debian-trixie]='{"name":"debian-trixie","kind":"linux-container","runs-on":"ubuntu-24.04","container":"docker.io/library/debian:trixie","pkg":"apt"}'
    [fedora-43]='{"name":"fedora-43","kind":"linux-container","runs-on":"ubuntu-24.04","container":"quay.io/fedora/fedora:43","pkg":"dnf"}'
    [fedora-44]='{"name":"fedora-44","kind":"linux-container","runs-on":"ubuntu-24.04","container":"quay.io/fedora/fedora:44","pkg":"dnf"}'
    [opensuse-tumbleweed]='{"name":"opensuse-tumbleweed","kind":"linux-container","runs-on":"ubuntu-24.04","container":"registry.opensuse.org/opensuse/tumbleweed:latest","pkg":"zypper"}'
    [cachyos]='{"name":"cachyos","kind":"linux-container","runs-on":"ubuntu-24.04","container":"docker.io/cachyos/cachyos:latest","pkg":"pacman"}'
)

declare -A affected=()

mark() { affected[$1]=1; }

mark_all() {
    local t
    for t in "${ALL_TARGETS[@]}"; do mark "$t"; done
}

# Map a case-branch OS label to one or more target names.
mark_os_label() {
    case "$1" in
        mac)                  mark mac ;;
        cachyos)              mark cachyos ;;
        opensuse-tumbleweed)  mark opensuse-tumbleweed ;;
        fedora)               mark fedora-43; mark fedora-44 ;;
        ubuntu)               mark ubuntu ;;
        debian)               mark debian-trixie ;;
        all|*)                mark_all ;;
    esac
}

# Walk a script, label each line by the OS case branch it belongs to.
# Lines outside any `case "$os" in … esac` block, or inside `*)` arms,
# or inside an unrecognized case header, get the label "all".
extract_sections() {
    awk '
        function trim(s) { sub(/^[[:space:]]+/, "", s); sub(/[[:space:]]+$/, "", s); return s }
        BEGIN { in_case=0; labels="all" }
        {
            line=$0
            if (!in_case) {
                if (line ~ /^[[:space:]]*case[[:space:]]+"?\$\{?os\}?"?[[:space:]]+in[[:space:]]*$/) {
                    in_case=1; labels="all"
                    print labels "\t" line; next
                }
                print "all\t" line; next
            }
            if (line ~ /^[[:space:]]*esac([[:space:]]|$)/) {
                print "all\t" line; in_case=0; labels="all"; next
            }
            if (line ~ /^[[:space:]]*[A-Za-z0-9_*][A-Za-z0-9_*|-]*\)/) {
                hdr=line; sub(/\).*/, "", hdr); hdr=trim(hdr)
                if (hdr ~ /\*/) { labels="all" }
                else {
                    labels=""
                    n=split(hdr, parts, "|")
                    for (i=1;i<=n;i++) {
                        p=trim(parts[i])
                        if (p=="") continue
                        if (p ~ /^(mac|cachyos|opensuse-tumbleweed|fedora|ubuntu|debian)$/) {
                            labels = (labels=="" ? p : labels "," p)
                        } else {
                            labels="all"; break
                        }
                    }
                    if (labels=="") labels="all"
                }
                print labels "\t" line; next
            }
            if (line ~ /^[[:space:]]*;;[[:space:]]*$/) {
                print labels "\t" line; labels="all"; next
            }
            print labels "\t" line
        }
    '
}

# Print only lines whose label set contains $1, in their original order.
sections_for() {
    awk -F'\t' -v want="$1" '
        {
            n=split($1, parts, ",")
            for (i=1;i<=n;i++) if (parts[i]==want) { print $2; next }
        }
    '
}

# Hash all labels present in either base or head, compare per label.
classify_script() {
    local rel="$1"
    local base_sections head_sections
    base_sections=$(git show "origin/master:$rel" 2>/dev/null | extract_sections || true)
    head_sections=$(extract_sections < "$rel")

    local labels lbl base_hash head_hash
    labels=$(printf '%s\n%s\n' "$base_sections" "$head_sections" \
        | awk -F'\t' 'NF { print $1 }' \
        | tr ',' '\n' \
        | sort -u)

    for lbl in $labels; do
        base_hash=$(printf '%s\n' "$base_sections" | sections_for "$lbl" | sha1sum | awk '{print $1}')
        head_hash=$(printf '%s\n' "$head_sections" | sections_for "$lbl" | sha1sum | awk '{print $1}')
        if [[ "$base_hash" != "$head_hash" ]]; then
            mark_os_label "$lbl"
        fi
    done
}

# --- Walk changed files ---
files=$(git diff --name-only origin/master...HEAD)

while IFS= read -r path; do
    [[ -z "$path" ]] && continue
    case "$path" in
        justfile|init.sh|scripts/shell-init.sh|.github/workflows/recipe.yml)
            mark_all ;;
        .github/scripts/recipe/*|.github/actions/linux-container-setup/*)
            mark_all ;;
        flake.nix|flake.lock|nix/*|hosts/*|.github/actions/mac-nix-setup/*)
            mark mac ;;
        os-init/debian-init.sh)
            mark debian-trixie; mark ubuntu ;;
        os-init/ubuntu-init.sh)
            mark ubuntu ;;
        os-init/fedora-init.sh)
            mark fedora-43; mark fedora-44 ;;
        os-init/opensuse-tumbleweed-init.sh)
            mark opensuse-tumbleweed ;;
        os-init/cachyos-init.sh)
            mark cachyos ;;
        "scripts/install-${RECIPE}.sh")
            if [[ -f "$path" ]]; then
                classify_script "$path"
            else
                mark_all
            fi
            ;;
        *)
            : ;;
    esac
done <<< "$files"

# flatpak has no mac path (mac case is a no-op message).
if [[ "$RECIPE" == "flatpak" ]]; then
    unset 'affected[mac]'
fi

# Emit JSON.
out="["
sep=""
for t in "${ALL_TARGETS[@]}"; do
    if [[ -n "${affected[$t]:-}" ]]; then
        out+="${sep}${TARGET_JSON[$t]}"
        sep=","
    fi
done
out+="]"
echo "$out"
