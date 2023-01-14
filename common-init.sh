#!/usr/bin/env bash
LOCATION=$(pwd)

echo "rust-analyzer installation"
#################################
bash "$LOCATION/rust-analyzer-linux-update.sh"

echo "common installation"
##########################
if ! command -v rustup &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
else
    rustup update
fi
curl -fsSL https://git.io/zinit-install | sh
chsh -s "$(which zsh)"

echo "install cargo packages"
#############################
while read -r line
do
    echo "Installing $line..."
    "$HOME/.cargo/bin/cargo" install "$line"
done < "$LOCATION/cargo.list"

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

echo "install packer.nvim"
git clone --depth 1 https://github.com/wbthomason/packer.nvim "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
