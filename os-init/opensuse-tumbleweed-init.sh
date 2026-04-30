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
PACKAGES=(fd dust clang eza editorconfig ripgrep ShellCheck openssh typst gawk gcc make cmake curl fontconfig p7zip)
if [[ -z "${DOTFILES_SKIP_UPDATE:-}" ]]; then
    sudo zypper ref
fi
sudo zypper in -y "${PACKAGES[@]}"
