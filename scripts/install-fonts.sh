#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/../fonts"
bash fira-math.sh install
bash fira-sans.sh install
bash inconsolata.sh install
bash lxgw-wenkai-tc.sh install
