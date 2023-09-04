#!/usr/bin/env bash
LOC=$(pwd)
# dotfiles location
S_LOC=$(cd -- "$(dirname -- "{BASH_SOURCE[0]}")" &> /dev/null && pwd)
D_LOC="$S_LOC"/..

error_exit() {
    echo "something's wrong in common-init, exiting"
    cd "$LOC" || exit 1
    exit 1
}

prompt() {
    local available=$(($(tput cols) - ${#1} - 2))
    local left=$(($available / 2))
    local right=$(($available - $left))

    test $left -gt 0 && printf -- "=%.0s" $(seq 1 $left)
    printf " %s " "$1"
    test $right -gt 0 && printf -- "=%.0s" $(seq 1 $right)
    echo ""
}

cd "$S_LOC" || error_exit

prompt "installations"
####################
bash rust-install.sh || error_exit
# always the last
bash cargo-packages.sh || error_exit
bash lsp-install.sh || error_exit

prompt "fonts installation"
#########################
cd "$D_LOC/fonts" || error_exit
bash font-install-all.sh

prompt "home directory sync"
##########################
cd "$HOME" || error_exit
for f in "$D_LOC/home/".*
do
    if [ "${f##*/}" != "." -a "${f##*/}" != ".." ]; then
       echo "Linking $f"
       ln -sf "$f" .
    fi
done

prompt "config/ sync"
###################
mkdir -p "$HOME/.config"
cd "$HOME/.config" || error_exit
for d in "$D_LOC/config/"*/
do
    echo "Linking $d"
    ln -sf "$d" .
done

cd "$LOC" || error_exit
