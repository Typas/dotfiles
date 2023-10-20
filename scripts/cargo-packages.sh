#!/usr/bin/env bash

PACKAGES=""
echo "install cargo packages"

# do nothing if cargo doesn't exist
if ! command -v cargo > /dev/null; then
    exit
fi

# always install, since I don't know how to check
if ! cargo install --list | grep cargo-update > /dev/null; then
    PACKAGES+=" cargo-update"
fi

if ! command -v bat > /dev/null; then
    PACKAGES+=" bat"
fi

if ! command -v eza > /dev/null; then
    PACKAGES+=" eza"
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

if [ "$PACKAGES" ]; then
    echo "install $PACKAGES"
    cargo install "$PACKAGES"
fi
