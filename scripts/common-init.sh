#!/usr/bin/env bash

echo "installations"
####################
bash "$LOCATION/scripts/haskell-install.sh"
bash "$LOCATION/scripts/julia-install.sh"
bash "$LOCATION/scripts/rust-install.sh"
# always the last
bash "$LOCATION/scripts/cargo-packages.sh"
bash "$LOCATION/scripts/lsp-install.sh"

echo "home directory sync"
##########################
cd "$HOME" || exit
for f in "$LOCATION/home/".*
do
    echo "Linking $f"
    ln -sf "$f" .
done
cd "$LOCATION" || exit

echo "config/ sync"
###################
mkdir -p "$HOME/.config"
cd "$HOME/.config" || exit
for d in "$LOCATION/config/"*/
do
    echo "Linking $d"
    ln -sf "$d" .
done
cd "$LOCATION" || exit

