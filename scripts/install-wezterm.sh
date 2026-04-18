#!/usr/bin/env bash
set -euo pipefail
os="${1:?usage: install-wezterm.sh <os>}"

if command -v wezterm &>/dev/null; then
    echo "wezterm is already installed"
    exit 0
fi

case "$os" in
    mac)
        echo "wezterm is managed by nix-darwin (nix/home/packages.nix); edit and run 'just init'"
        ;;
    fedora)
        if ! dnf copr list --enabled 2>/dev/null | grep -q "wezfurlong/wezterm-nightly"; then
            sudo dnf copr enable -y wezfurlong/wezterm-nightly
        fi
        sudo dnf install -y wezterm
        ;;
    opensuse*)
        sudo zypper ar -fG https://copr.fedorainfracloud.org/coprs/wezfurlong/wezterm-nightly/repo/opensuse-tumbleweed/wezfurlong-wezterm-nightly-opensuse-tumbleweed.repo || true
        sudo zypper in -y wezterm
        ;;
    cachyos)
        sudo pacman -S --needed --noconfirm wezterm
        ;;
    debian|ubuntu)
        if [ ! -f /usr/share/keyrings/wezterm-fury.gpg ]; then
            curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
            echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
            sudo apt-get update
        fi
        sudo apt-get install -y wezterm
        ;;
    *)
        echo "unsupported OS: $os"
        exit 1
        ;;
esac
