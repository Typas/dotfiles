#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/../fonts"
source ./fira-math.sh install
source ./fira-sans.sh install
source ./inconsolata.sh install
source ./lxgw-wenkai-tc.sh install
