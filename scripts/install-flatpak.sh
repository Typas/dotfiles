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
        if [ ! -S /run/dbus/system_bus_socket ]; then
            sudo mkdir -p /run/dbus
            sudo dbus-daemon --system --fork
        fi
        sudo pacman -S --needed --noconfirm flatpak
        ;;
    fedora)
        sudo dnf install -y flatpak
        ;;
    opensuse-tumbleweed)
        sudo zypper install -y flatpak
        ;;
    *)
        echo "unsupported OS: $os" >&2
        exit 1
        ;;
esac

flatpak --version
