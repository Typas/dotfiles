#!/usr/bin/env bash
set -euo pipefail
D_LOC="${D_LOC:?D_LOC must be set}"

sudo -v

prompt() {
    local available=$(($(tput cols) - ${#1} - 2))
    local left=$((available / 2))
    local right=$((available - left))

    test $left -gt 0 && printf -- "=%.0s" $(seq 1 $left)
    printf " %s " "$1"
    test $right -gt 0 && printf -- "=%.0s" $(seq 1 $right)
    echo ""
}

prompt "system package installations"
PACKAGES=(dust clang shellcheck typst openssh gcc cmake curl fontconfig p7zip)
if [[ -z "${DOTFILES_SKIP_UPDATE:-}" ]]; then
    sudo pacman -Syu --noconfirm
fi
sudo pacman -S --needed --noconfirm --ask=4 "${PACKAGES[@]}" 2>&1 | grep -Ev 'is up to date -- skipping|there is nothing to do'
