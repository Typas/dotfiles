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
        if ! command -v brew &>/dev/null; then
            curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
        fi
        brew update
        ;;
    fedora)
        sudo dnf update -y
        ;;
    opensuse*)
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
        mac)       brew install just ;;
        fedora)    sudo dnf install -y just ;;
        opensuse*) sudo zypper in -y just ;;
        cachyos)   sudo pacman -S --noconfirm just ;;
        ubuntu|debian) sudo apt-get install -y just ;;
    esac
fi

# hand off to justfile
cd "$D_LOC"
just update="false" init
