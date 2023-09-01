#!/usr/bin/env bash
LOC=$(pwd)
# script location
S_LOC=$(cd -- "$(dirname -- "{BASH_SOURCE[0]}")" &> /dev/null && pwd)
# dotfiles location
D_LOC="$S_LOC/../"

error_exit() {
    echo "something's wrong, exiting"
    cd "$LOC" || exit 1
    exit 1
}


cd "$S_LOC" || error_exit

echo "installations"
####################
bash haskell-install.sh || error_exit
bash julia-install.sh || error_exit
bash rust-install.sh || error_exit
# always the last
bash cargo-packages.sh || error_exit
bash lsp-install.sh || error_exit

echo "home directory sync"
##########################
cd "$HOME" || error_exit
for f in "$D_LOC/home/".*
do
    echo "Linking $f"
    ln -sf "$f" .
done
cd "$LOCATION" || error_exit

echo "config/ sync"
###################
mkdir -p "$HOME/.config"
cd "$HOME/.config" || error_exit
for d in "$LOCATION/config/"*/
do
    echo "Linking $d"
    ln -sf "$d" .
done
cd "$LOC" || error_exit
