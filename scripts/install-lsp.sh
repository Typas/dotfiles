#!/usr/bin/env bash
set -euo pipefail

SCRIPTS_DIR="$(dirname "$0")"

# rust-analyzer
if ! command -v rustup &>/dev/null; then echo "rustup not found, skipping rust-analyzer"
elif command -v rust-analyzer &>/dev/null; then echo "rust-analyzer already installed"
else rustup component add rust-analyzer; fi &

# julia lsp
if ! command -v julia &>/dev/null; then echo "julia not found, skipping julia LSP"
else julia "$SCRIPTS_DIR/install-lsp-julia.jl"; fi &

# gopls
if ! command -v go &>/dev/null; then echo "go not found, skipping gopls"
elif command -v gopls &>/dev/null; then echo "gopls already installed"
else go install golang.org/x/tools/gopls@latest; fi &

# hls
if ! command -v ghcup &>/dev/null; then echo "ghcup not found, skipping hls"
elif ghcup whereis hls &>/dev/null; then echo "hls already installed"
else ghcup install hls; fi &

# texlab
if ! command -v cargo &>/dev/null; then echo "cargo not found, skipping texlab"
elif command -v texlab &>/dev/null; then echo "texlab already installed"
else cargo install texlab; fi &

# bash-language-server
if ! command -v npm &>/dev/null; then echo "npm not found, skipping bash-language-server"
elif npm view bash-language-server &>/dev/null 2>&1; then echo "bash-language-server already installed"
else npm i -g bash-language-server; fi &

wait
