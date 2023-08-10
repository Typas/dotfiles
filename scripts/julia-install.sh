#!/usr/bin/env sh
if ! command -v juliaup > /dev/null; then
    curl -fsSL https://install.julialang.org | sh -s -- -y
fi
