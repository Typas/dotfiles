#!/usr/bin/env bash

mkdir -p "$HOME/.local/bin"
curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - > "$HOME/.local/bin/rust-analyzer"
chmod +x "$HOME/.local/bin/rust-analyzer"
