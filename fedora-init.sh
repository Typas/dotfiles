#!/usr/bin/env bash
LOCATION=$(pwd)

# fedora-specific
bash "$LOCATION/rust-analyzer-linux-update.sh"

sudo dnf -y install "$(cat "$LOCATION/package.list")"

bash "$LOCATION/common-init.sh"
