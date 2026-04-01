#!/usr/bin/env bash
set -euo pipefail
D_LOC="${D_LOC:?D_LOC must be set}"

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
prompt "wezterm COPR repo"
sudo zypper ar -fG https://copr.fedorainfracloud.org/coprs/wezfurlong/wezterm-nightly/repo/opensuse-tumbleweed/wezfurlong-wezterm-nightly-opensuse-tumbleweed.repo || true

PACKAGES=(fd dust emacs clang eza editorconfig ShellCheck openssh typst wezterm)
mapfile -t extra < "$D_LOC"/lists/package.list
PACKAGES+=("${extra[@]}")
if [[ -z "${DOTFILES_SKIP_UPDATE:-}" ]]; then
    sudo zypper ref
fi
sudo zypper in -y "${PACKAGES[@]}"

prompt "flatpak setup"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
