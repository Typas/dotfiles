#!/usr/bin/env bash
LOCATION=$(pwd)

# fedora-specific

while read -r line
do
sudo dnf install -y "$line"
done < "$LOCATION/package.list"

echo "rust-analyzer installation"
#################################
bash "$LOCATION/rust-analyzer-linux-update.sh"

echo "flatpak installations"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.wezfurlong.wezterm

bash "$LOCATION/common-init.sh"
