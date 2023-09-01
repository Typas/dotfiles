#!/usr/bin/env bash
LOC=$(pwd)
# dotfiles location
D_LOC=$(cd -- "$(dirname -- "{BASH_SOURCE[0]}")" &> /dev/null && pwd)

error_exit() {
    echo "something's wrong in opensuse-init.sh"
    exit 1
}

echo "system package installations"
PACKAGES="fd dust emacs texlive-xetex clang "
PACKAGES+=$(cat "$D_LOC"/lists/package.list)
PACKAGES=$(echo "$PACKAGES" | tr " " "\n")
sudo zypper ref
sudo zypper in -y "$PACKAGES"

echo "flatpak installations"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.wezfurlong.wezterm
