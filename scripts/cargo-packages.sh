#!/usr/bin/env bash

echo "install cargo packages"

# do nothing if cargo doesn't exist
if ! command -v cargo > /dev/null; then
    exit
fi

# always install, since I don't know how to check
PACKAGES="cargo-update"

if ! command -v bat > /dev/null; then
    PACKAGES+=" bat"
fi

if ! command -v exa > /dev/null; then
    PACKAGES+=" exa"
fi

if ! command -v rg > /dev/null; then
    PACKAGES+=" ripgrep"
fi

if ! command -v zoxide > /dev/null; then
    PACKAGES+=" zoxide"
fi

if ! command -v dust > /dev/null; then
    PACKAGES+=" du-dust"
fi

if ! command -v fd > /dev/null; then
    PACKAGES+=" fd-find"
fi

if ! command -v texlab > /dev/null; then
    PACKAGES+=" texlab"
fi

cargo install "$PACKAGES"
