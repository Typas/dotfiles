#!/usr/bin/env sh
if ! command -v rustup > /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi
rustup default stable
