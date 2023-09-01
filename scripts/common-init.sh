#!/usr/bin/env bash
LOC=$(pwd)
# dotfiles location
S_LOC=$(cd -- "$(dirname -- "{BASH_SOURCE[0]}")" &> /dev/null && pwd)
D_LOC="$S_LOC"/../

error_exit() {
    echo "something's wrong in common-init, exiting"
    cd "$LOC" || exit 1
    exit 1
}

cd "$S_LOC" || error_exit

echo "installations"
####################
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

echo "config/ sync"
###################
mkdir -p "$HOME/.config"
cd "$HOME/.config" || error_exit
for d in "$D_LOC/config/"*/
do
    echo "Linking $d"
    ln -sf "$d" .
done

cd "$LOC" || error_exit
