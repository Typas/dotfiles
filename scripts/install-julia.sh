#!/usr/bin/env bash
set -euo pipefail

os="${1:?usage: install-julia.sh <os>}"

if command -v juliaup &>/dev/null; then
    echo "julia has already been installed"
else
    curl -fsSL https://install.julialang.org | sh -s -- -y
    case "$os" in
        mac) source ~/.zshrc ;;
        *)   source ~/.bashrc ;;
    esac
fi
