#!/usr/bin/env bash
LOC=$(pwd)
# dotfiles location
D_LOC=$(cd -- "$(dirname -- "{BASH_SOURCE[0]}")" &> /dev/null && pwd)

error_exit() {
    echo "something's wrong in opensuse-init.sh"
    exit 1
}

prompt() {
    local available=$(($(tput cols) - ${#1} - 2))
    local left=$(($available / 2))
    local right=$(($available - $left))

    test $left -gt 0 && printf -- "=%.0s" $(seq 1 $left)
    printf " %s " "$1"
    test $right -gt 0 && printf -- "=%.0s" $(seq 1 $right)
    echo ""
}

prompt "system package installations"
PACKAGES=(fd dust emacs texlive-xetex clang)
PACKAGES+=($(cat "$D_LOC"/lists/package.list))
sudo zypper ref
sudo zypper in -y ${PACKAGES[@]}

prompt "flatpak installations"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.wezfurlong.wezterm
