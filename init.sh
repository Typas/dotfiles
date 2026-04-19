#!/usr/bin/env bash
set -euo pipefail

D_LOC=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

OS="unknown"

# detect OS
KERNEL=$(uname -s)
case $KERNEL in
    Darwin)
        OS=mac ;;
    Linux)
        OS="$(grep "^ID=" /etc/os-release | sed 's/ID=//;s/^"//;s/"$//')" ;;
    *)
        echo "unsupported system ($KERNEL)"
        exit 1
esac

# update package manager and install just
case "$OS" in
    mac)
        if ! command -v nix &>/dev/null; then
            sh <(curl -L https://nixos.org/nix/install) --daemon
            if [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
                . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
            fi
        fi
        mkdir -p "$HOME/.config/nix"
        if ! grep -q "experimental-features" "$HOME/.config/nix/nix.conf" 2>/dev/null; then
            echo "experimental-features = nix-command flakes" >> "$HOME/.config/nix/nix.conf"
        fi
        ;;
    fedora)
        sudo dnf update -y
        ;;
    opensuse-tumbleweed)
        sudo zypper ref
        ;;
    cachyos)
        sudo pacman -Syu --noconfirm
        ;;
    ubuntu|debian)
        sudo apt-get update
        ;;
    *)
        echo "unsupported system ($OS)"
        exit 1
esac

# install just if not present
if ! command -v just &>/dev/null; then
    case "$OS" in
        mac)       nix profile add nixpkgs#just ;;
        fedora)    sudo dnf install -y just ;;
        opensuse-tumbleweed) sudo zypper in -y just ;;
        cachyos)   sudo pacman -S --noconfirm just ;;
        ubuntu|debian) sudo apt-get install -y just ;;
    esac
fi

# hand off to justfile
cd "$D_LOC"
just update="false" init

# probe: verify bootstrap/shared accepts init.sh edits
