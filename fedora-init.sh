#!/usr/bin/env bash
LOCATION=$(pwd)

# fedora-specific

while read -r line
do
sudo dnf install -y "$line"
done < "$LOCATION/package.list"

echo "rust-analyzer installation"
#################################
bash "$LOCATION/rust-analyzer-linux-update.sh"

bash "$LOCATION/common-init.sh"
