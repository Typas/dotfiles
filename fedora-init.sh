#!/usr/bin/env bash
LOCATION=$(pwd)

# fedora-specific
bash "$LOCATION/rust-analyzer-linux-update.sh"

while read -r line
do
sudo dnf install -y "$line"
done < "$LOCATION/package.list"

bash "$LOCATION/common-init.sh"
