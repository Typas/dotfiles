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

if command -v ghcup > /dev/null && ! ghcup whereis hls > /dev/null 2> /dev/null
then
    ghcup install hls
fi

# python - pyright?, but should be auto installed
# use pip show to check

# bash-language-server - install via npm, should be auto installed
if command -v npm > /dev/null && ! npm view bash-language-server > /dev/null 2> /dev/null
then
    npm i -g bash-language-server
fi
