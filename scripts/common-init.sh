#!/usr/bin/env bash
set -euo pipefail
D_LOC="${D_LOC:?D_LOC must be set}"

prompt() {
    local available=$(($(tput cols) - ${#1} - 2))
    local left=$((available / 2))
    local right=$((available - left))

    test $left -gt 0 && printf -- "=%.0s" $(seq 1 $left)
    printf " %s " "$1"
    test $right -gt 0 && printf -- "=%.0s" $(seq 1 $right)
    echo ""
}

prompt "default shell"
if [ "$SHELL" != "$(which bash)" ]; then
    sudo usermod -s "$(which bash)" "$USER"
fi

prompt "installations"
####################
bash rust-install.sh
# always the last
bash cargo-packages.sh

prompt "required fonts installation"
#########################
cd "$D_LOC/fonts"
bash fira-code.sh install
bash juliamono.sh install
bash noto-sans-cjk.sh install
bash noto-serif-cjk.sh install
bash typas-code.sh install
bash typas-mono-cjk-tc.sh install

prompt "home directory sync"
##########################
cd "$HOME"
for f in "$D_LOC/home/".*
do
    if [ "${f##*/}" != "." ] && [ "${f##*/}" != ".." ]; then
       echo "Linking $f"
       ln -sf "$f" .
    fi
done

prompt "config/ sync"
###################
mkdir -p "$HOME/.config"
cd "$HOME/.config"
for d in "$D_LOC/config/"*/
do
    echo "Linking $d"
    ln -sf "$d" .
done
