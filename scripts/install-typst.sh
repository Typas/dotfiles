#!/usr/bin/env bash
set -euo pipefail

os="${1:?usage: install-typst.sh <os> <install|update>}"
action="${2:-install}"

usage() {
    echo "usage: install-typst.sh <os> <install|update>" >&2
    exit 1
}

if [[ "$os" == "mac" ]]; then
    if ! command -v nix >/dev/null 2>&1; then
        echo "nix not found on PATH; install Nix first" >&2
        exit 1
    fi
    case "$action" in
        install)
            if command -v typst >/dev/null 2>&1; then
                echo "typst is already installed: $(typst --version)"
                exit 0
            fi
            nix profile install nixpkgs#typst
            ;;
        update)
            nix profile upgrade nixpkgs#typst
            ;;
        *) usage ;;
    esac
    exit 0
fi

if [[ "$os" == "cachyos" ]]; then
    case "$action" in
        install) sudo pacman -S --needed --noconfirm typst ;;
        update)  sudo pacman -S --noconfirm typst ;;
        *) usage ;;
    esac
    exit 0
fi

case "$os" in
    fedora|opensuse-tumbleweed|ubuntu|debian) ;;
    *) echo "unsupported OS for typst: $os" >&2; exit 1 ;;
esac

if ! command -v cargo >/dev/null 2>&1; then
    echo "cargo not found on PATH; run 'just init' first" >&2
    exit 1
fi

case "$action" in
    install)
        if command -v typst >/dev/null 2>&1; then
            echo "typst is already installed: $(typst --version)"
            exit 0
        fi
        cargo install --locked typst-cli
        ;;
    update)
        cargo install --locked typst-cli
        ;;
    *) usage ;;
esac

echo "installed $(typst --version)"
