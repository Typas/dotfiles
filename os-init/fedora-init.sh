#!/usr/bin/env bash
LOC=$(pwd)
# script location
S_LOC=$(cd -- "$(dirname -- "{BASH_SOURCE[0]}")" &> /dev/null && pwd)
# dotfiles location
D_LOC="$S_LOC/../"

error_exit() {
    echo "something's wrong, exiting"
    cd "$LOC" || exit 1
    exit 1
}

cd "$S_LOC" || error_exit

echo "system package installations"
sudo dnf install -y "$(cat "$D_LOC"/lists/package.list)"
sudo dnf install -y fd-find emacs texlive-xetex

echo "flatpak installations"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.wezfurlong.wezterm

cd "$LOC" || error_exit
