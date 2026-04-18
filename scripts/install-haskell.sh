#!/usr/bin/env bash
set -euo pipefail

os="${1:?usage: install-haskell.sh <os>}"

if command -v ghcup &>/dev/null; then
    echo "haskell has already been installed"
else
    case "$os" in
        mac) ;; # Xcode command line tools covers everything
        cachyos)
            sudo pacman -S --needed --noconfirm gmp ncurses make pkg-config 2>&1 | grep -v 'is up to date -- skipping' ;;
        fedora)
            sudo dnf install -y gmp-devel ncurses-devel make pkgconfig gcc-c++ xz ;;
        opensuse-tumbleweed)
            sudo zypper in -y gmp-devel ncurses-devel make pkg-config gcc-c++ xz ;;
        ubuntu|debian)
            sudo apt-get install -y libgmp-dev libncurses-dev make pkg-config g++ xz-utils ;;
    esac
    curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh -s -- -y
    case "$os" in
        mac) source ~/.zshrc ;;
        *)   source ~/.bashrc ;;
    esac
fi
