#!/usr/bin/env bash
LOC=$(pwd)
export LOC
# dotfiles location
D_LOC=$(cd -- "$(dirname -- "{BASH_SOURCE[0]}")" &> /dev/null && pwd)

error_exit() {
    echo "something's wrong in ubuntu-init.sh"
    exit 1
}

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
PACKAGES=(fd-find clang flatpak gcc editorconfig shellcheck)
mapfile -t extra < "$D_LOC"/lists/package.list
PACKAGES+=("${extra[@]}")
if [[ -z "${DOTFILES_SKIP_UPDATE:-}" ]]; then
    sudo apt-get update
fi
sudo apt-get install -y "${PACKAGES[@]}"
if ! command -v fd > /dev/null 2>&1; then 
    mkdir -p ~/.local/bin
    ln -s "$(which fdfind)" ~/.local/bin/fd
    source ~/.bashrc
    source ~/.profile
fi

prompt "flatpak installations"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub org.wezfurlong.wezterm
