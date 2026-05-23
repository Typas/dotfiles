#!/usr/bin/env bash
set -euo pipefail

os="${1:?usage: install-julia.sh <os>}"

if command -v juliaup &>/dev/null; then
    echo "julia has already been installed"
else
    case "$os" in
        mac|fedora|opensuse-tumbleweed|cachyos|ubuntu|debian) ;;
        *) echo "unsupported OS: $os" >&2; exit 1 ;;
    esac
    curl -fsSL https://install.julialang.org | sh -s -- -y
    export PATH="$HOME/.juliaup/bin:$PATH"
    julia --version
fi
