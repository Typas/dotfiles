#!/usr/bin/env bash
LOCATION=$(pwd)

# fedora-specific
echo "system package installations"
sudo dnf install -y "$(cat "$LOCATION"/package.list)"
sudo dnf install -y fd-find emacs texlive-xetex

echo "flatpak installations"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.wezfurlong.wezterm

echo "common initialization"
bash LOCATION="$LOCATION" "$LOCATION/scripts/common-init.sh"

echo "shell initialization"
bash "$LOCATION/scripts/oh-my-bash-install.sh"
ln -sf "$LOCATION/settings-bash/.bashrc" "$HOME/.bashrc"
