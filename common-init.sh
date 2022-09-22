#!/usr/bin/env bash
LOCATION=$(pwd)

echo "rust-analyzer installation"
#################################
bash "$LOCATION/rust-analyzer-linux-update.sh"

echo "common installation"
##########################
if ! command -v rustup &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi
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
