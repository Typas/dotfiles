#!/usr/bin/env bash
set -euo pipefail
os="${1:?usage: install-flatpak.sh <os>}"

case "$os" in
    mac)
        echo "flatpak is not supported on macOS"
        exit 0
        ;;
    debian|ubuntu)
        sudo apt-get install -y flatpak
        ;;
    cachyos)
        sudo pacman -S --needed --noconfirm flatpak
        ;;
    fedora|opensuse*)
        ;; # flatpak pre-installed
esac

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
