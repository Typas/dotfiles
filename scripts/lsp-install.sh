#!/usr/bin/env sh

# clangd should be installed with clang

if command -v rustup > /dev/null && ! command -v rust-analyzer > /dev/null
then
    rustup component add rust-analyzer
fi

if command -v julia > /dev/null; then
    julia "$LOCATION"/scripts/install-lsp-julia.jl
fi

if command -v go > /dev/null && ! command -v gopls > /dev/null
then
    go install golang.org/x/tools/gopls@latest
fi

# python - pyright?, but should be auto installed

# bash-language-server - install via npm, should be auto installed
