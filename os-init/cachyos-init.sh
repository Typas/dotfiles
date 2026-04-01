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
PACKAGES=(dust emacs-wayland clang flatpak shellcheck typst openssh wezterm)
mapfile -t extra < "$D_LOC"/lists/package.list
PACKAGES+=("${extra[@]}")
if [[ -z "${DOTFILES_SKIP_UPDATE:-}" ]]; then
    sudo pacman -Syu --noconfirm
fi
sudo pacman -S --needed --noconfirm --ask=4 "${PACKAGES[@]}" 2>&1 | grep -Ev 'is up to date -- skipping|there is nothing to do'

prompt "flatpak setup"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
