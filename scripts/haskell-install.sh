#!/usr/bin/env sh
if ! command -v ghcup > /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://get-getup.haskell.org | sh -s -- -y
fi
