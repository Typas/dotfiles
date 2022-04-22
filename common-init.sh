#!/usr/bin/env bash
LOCATION=$(pwd)

echo "common installation"
##########################
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
curl -fsSL https://git.io/zinit-install | sh
chsh -s "$(which zsh)"

echo "install cargo packages"
#############################
while read -r line
do
    "$HOME/.cargo/bin/cargo" install "$line"
done < "$LOCATION/cargo.list"

echo "home directory sync"
##########################
cd "$HOME" || exit
for f in "$LOCATION/home/".*
do
    ln -sf "$f" .
done
cd "$LOCATION" || exit

echo "config/ sync"
###################
mkdir -p "$HOME/.config"
cd "$HOME/.config" || exit
for d in "$LOCATION/config/"*/
do
    ln -sf "$d" .
done
cd "$LOCATION" || exit

echo "texmf/ sync"
#######################
mkdir -p "$HOME/texmf/tex/latex"
cd "$HOME/texmf/tex/latex" || exit
ln -sf "$LOCATION/texmf/tex/latex/local" .
cd "$LOCATION" || exit

echo "doom.d/ sync"
##########################
cd "$HOME" || exit
ln -sf "$LOCATION/doom.d" ".doom.d"
cd "$LOCATION" || exit

echo "doom emacs installation"
##############################
git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
"$HOME/.emacs.d/bin/doom" install
"$HOME/.emacs.d/bin/doom" sync
