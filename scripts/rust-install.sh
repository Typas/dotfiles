#!/usr/bin/env sh
if ! command -v rustup > /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    . "$HOME/.cargo/env"
fi
rustup default stable

# cargo-binstall fetches prebuilt binaries instead of compiling from source,
# so cargo-packages.sh doesn't pay the rust-compile tax on every distro.
if ! command -v cargo-binstall > /dev/null; then
    curl -L --proto '=https' --tlsv1.2 -sSf \
        https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
fi
