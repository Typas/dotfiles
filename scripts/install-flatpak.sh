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
        [ -S /run/dbus/system_bus_socket ] || sudo dbus-daemon --system --fork
        sudo pacman -S --needed --noconfirm flatpak
        ;;
    fedora|opensuse-tumbleweed)
        ;; # flatpak pre-installed
    *)
        echo "unsupported OS: $os" >&2
        exit 1
        ;;
esac

flatpak --version
