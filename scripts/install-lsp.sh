#!/usr/bin/env bash
set -euo pipefail

SCRIPTS_DIR="$(dirname "$0")"

# shellcheck source=parallel-progress.sh
source "$SCRIPTS_DIR/parallel-progress.sh"

# rust-analyzer
install_rust_analyzer() {
    if ! command -v rustup &>/dev/null; then echo "rustup not found, skipping rust-analyzer"
    elif command -v rust-analyzer &>/dev/null; then echo "rust-analyzer already installed"
    else rustup component add rust-analyzer; fi
}

# julia lsp
install_julia_lsp() {
    if ! command -v julia &>/dev/null; then echo "julia not found, skipping julia LSP"
    else julia "$SCRIPTS_DIR/install-lsp-julia.jl"; fi
}

# gopls
install_gopls() {
    if ! command -v go &>/dev/null; then echo "go not found, skipping gopls"
    elif command -v gopls &>/dev/null; then echo "gopls already installed"
    else go install golang.org/x/tools/gopls@latest; fi
}

# hls
install_hls() {
    if ! command -v ghcup &>/dev/null; then echo "ghcup not found, skipping hls"
    elif ghcup whereis hls &>/dev/null; then echo "hls already installed"
    else ghcup install hls; fi
}

# texlab
install_texlab() {
    if ! command -v cargo &>/dev/null; then echo "cargo not found, skipping texlab"
    elif command -v texlab &>/dev/null; then echo "texlab already installed"
    else cargo install texlab; fi
}

# tinymist
install_tinymist() {
    if ! command -v cargo &>/dev/null; then echo "cargo not found, skipping tinymist"
    elif command -v tinymist &>/dev/null; then echo "tinymist already installed"
    else cargo install tinymist; fi
}

# bash-language-server
install_bash_lsp() {
    if ! command -v npm &>/dev/null; then echo "npm not found, skipping bash-language-server"
    elif npm view bash-language-server &>/dev/null 2>&1; then echo "bash-language-server already installed"
    else npm i -g bash-language-server; fi
}

# ruff (Python linter/LSP)
install_ruff() {
    if command -v ruff &>/dev/null; then echo "ruff already installed"
    elif command -v uv &>/dev/null; then uv tool install ruff
    elif command -v cargo &>/dev/null; then cargo install ruff
    else echo "neither uv nor cargo found, skipping ruff"; fi
}

run_parallel "rust-analyzer" install_rust_analyzer
run_parallel "julia LSP"     install_julia_lsp
run_parallel "gopls"          install_gopls
run_parallel "hls"            install_hls
run_parallel "texlab"         install_texlab
run_parallel "tinymist"       install_tinymist
run_parallel "bash-lsp"       install_bash_lsp
run_parallel "ruff"           install_ruff

wait_parallel
