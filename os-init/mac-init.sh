#!/usr/bin/env zsh
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

echo "installing homebrew"
if ! command -v brew > /dev/null; then
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
else
    "homebrew is already installed"
fi

brew update

echo "installing wezterm"
if ! command -v wezterm > /dev/null; then
    brew tap wez/wezterm
    brew install --cask wez/wezterm/wezterm
else
    "wezterm is already installed"
fi

echo "installing packages"
brew install wget fd dust
brew install "$(cat "$D_LOC"/lists/package.list)"

echo "installing emacs"
if ! brew list | grep emacs-plus > /dev/null ; then
    brew tap d12frosted/emacs-plus
    brew install emacs-plus\
        --with-memeplex-slim-icon\
        --with-imagemagick\
        --with-native-comp
fi

cd "$LOC" || error_exit
