#!/usr/bin/env bash
# dotfiles location
S_LOC=$(cd -- "$(dirname -- "{BASH_SOURCE[0]}")" &> /dev/null && pwd)

# clangd should be installed with clang

if command -v rustup > /dev/null && ! command -v rust-analyzer > /dev/null
then
    rustup component add rust-analyzer || exit 1
fi

if command -v julia > /dev/null; then
    julia "$S_LOC"/install-lsp-julia.jl
fi

if command -v go > /dev/null && ! command -v gopls > /dev/null
then
    go install golang.org/x/tools/gopls@latest || exit 1
fi

if command -v ghcup > /dev/null && ! ghcup whereis hls > /dev/null 2> /dev/null
then
    ghcup install hls || exit 1
fi

# python - pyright?, but should be auto installed
# use pip show to check
# depends on system due to PEP 668
#if command -v pip3 > /dev/null && ! pip3 show pyright > /dev/null 2> /dev/null
#then
#    pip3 install pyright || exit 1
#fi

# bash-language-server - install via npm, should be auto installed
if command -v npm > /dev/null && ! npm view bash-language-server > /dev/null 2> /dev/null
then
    npm i -g bash-language-server || exit 1
fi
