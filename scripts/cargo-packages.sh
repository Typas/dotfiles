#!/usr/bin/env bash

CARGO_PACKAGES=()
echo "install cargo packages"

# do nothing if cargo doesn't exist
if ! command -v cargo > /dev/null; then
    exit
fi

# always install, since I don't know how to check
if ! cargo install --list | grep cargo-update > /dev/null; then
    CARGO_PACKAGES+=(cargo-update)
fi

if ! command -v bat > /dev/null; then
    CARGO_PACKAGES+=(bat)
fi

if ! command -v eza > /dev/null; then
    CARGO_PACKAGES+=(eza)
fi

if ! command -v rg > /dev/null; then
    CARGO_PACKAGES+=(ripgrep)
fi

if ! command -v zoxide > /dev/null; then
    CARGO_PACKAGES+=(zoxide)
fi

if ! command -v dust > /dev/null; then
    CARGO_PACKAGES+=(du-dust)
fi

if ! command -v fd > /dev/null; then
    CARGO_PACKAGES+=(fd-find)
fi

if ! command -v texlab > /dev/null; then
    CARGO_PACKAGES+=(texlab)
fi

if (( ${#CARGO_PACKAGES[@]} != 0 )) ; then
    echo "cargo install ${CARGO_PACKAGES[@]}"
    cargo install ${CARGO_PACKAGES[@]}
fi
