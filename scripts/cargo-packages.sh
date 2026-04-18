#!/usr/bin/env bash

CARGO_PACKAGES=()
echo "install core cargo packages"

# do nothing if cargo doesn't exist
if ! command -v cargo > /dev/null; then
    return
fi

if ! command -v eza > /dev/null; then
    CARGO_PACKAGES+=(eza)
fi

if ! command -v rg > /dev/null; then
    CARGO_PACKAGES+=(ripgrep)
fi

if ! command -v fd > /dev/null; then
    CARGO_PACKAGES+=(fd-find)
fi

if (( ${#CARGO_PACKAGES[@]} != 0 )) ; then
    # Prefer prebuilt binaries via cargo-binstall; it falls back to
    # `cargo install` automatically when no prebuilt is available.
    if command -v cargo-binstall > /dev/null; then
        echo "cargo binstall ${CARGO_PACKAGES[*]}"
        cargo binstall --no-confirm "${CARGO_PACKAGES[@]}"
    else
        echo "cargo install ${CARGO_PACKAGES[*]}"
        cargo install "${CARGO_PACKAGES[@]}"
    fi
fi
