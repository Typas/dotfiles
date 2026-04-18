#!/usr/bin/env bash
set -euo pipefail

os="${1:?usage: pacman-mask-cicku.sh <os>}"

case "$os" in
    cachyos) ;;
    *) echo "pacman-mask-cicku: only applicable to arch-like OSes; current=$os" >&2; exit 1 ;;
esac

FILES=(/etc/pacman.d/mirrorlist /etc/pacman.d/cachyos-mirrorlist)

any_changed=0
for f in "${FILES[@]}"; do
    [[ -f "$f" ]] || continue
    count=$(grep -cE '^[[:space:]]*Server[[:space:]]*=.*cicku\.me' "$f" || true)
    if [[ "$count" -eq 0 ]]; then
        echo "$f: no active cicku.me entries"
        continue
    fi
    echo "$f: masking $count cicku.me entries..."
    sudo sed -i.cicku-bak -E 's|^([[:space:]]*Server[[:space:]]*=.*cicku\.me.*)$|# \1|' "$f"
    any_changed=1
done

if [[ "$any_changed" -eq 1 ]]; then
    echo "refreshing pacman databases..."
    sudo pacman -Syy
else
    echo "nothing to mask; already clean."
fi
