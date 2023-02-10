#!/usr/bin/env bash
LOCATION=$(pwd)

echo "common installation"
##########################
if ! command -v rustup &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
else
    rustup update
fi

if ! command -v juliaup &> /dev/null; then
    curl -fsSL https://install.julialang.org | sh -s -- -y
else
    juliaup update
fi

if ! command -v ghcup &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://get-getup.haskell.org | sh -s -- -y
else
    ghcup upgrade
fi

# curl -fsSL https://git.io/zinit-install | sh
# chsh -s "$(which zsh)"
if [ ! -d "$HOME/.oh-my-bash" ]
then
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
    chsh -s "$(which bash)"
fi

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

