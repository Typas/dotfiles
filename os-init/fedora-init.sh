#!/usr/bin/env bash
set -euo pipefail
D_LOC="${D_LOC:?D_LOC must be set}"

#shellcheck disable=SC2004
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
sudo dnf copr enable -y wezfurlong/wezterm-nightly

PACKAGES=(fd-find emacs clang editorconfig ShellCheck openssh-clients wezterm)
mapfile -t extra < "$D_LOC"/lists/package.list
PACKAGES+=("${extra[@]}")
if [[ -z "${DOTFILES_SKIP_UPDATE:-}" ]]; then
    sudo dnf update
fi
sudo dnf install -y "${PACKAGES[@]}"

prompt "flatpak setup"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
