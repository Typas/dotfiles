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
PACKAGES=(fd-find clang gcc make gawk pkg-config libssl-dev editorconfig shellcheck openssh-client unzip cmake curl fontconfig p7zip-full)
if [[ -z "${DOTFILES_SKIP_UPDATE:-}" ]]; then
    sudo apt-get update
fi
sudo apt-get install -y "${PACKAGES[@]}"
if ! command -v fd > /dev/null 2>&1; then
    mkdir -p ~/.local/bin
    ln -sf "$(which fdfind)" ~/.local/bin/fd
    source ~/.bashrc
    source ~/.profile
fi
