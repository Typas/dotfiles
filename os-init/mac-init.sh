#!/usr/bin/env zsh
LOC=$(pwd)
# dotfiles location
D_LOC=$(cd -- "$(dirname -- "{ZSH_SOURCE[0]}")" &> /dev/null && pwd)

error_exit() {
    echo "something's wrong in mac-init.sh"
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

prompt "installing homebrew"
if ! command -v brew > /dev/null; then
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
else
    echo "homebrew is already installed"
fi

prompt "updating homebrew"
brew update

prompt "installing wezterm"
if ! command -v wezterm > /dev/null; then
    brew tap wez/wezterm
    brew install --cask wez/wezterm/wezterm
else
    echo "wezterm is already installed"
fi

prompt "installing packages"
PACKAGES=(wget fd dust)
PACKAGES+=($(cat "$D_LOC"/lists/package.list))
for item in "${PACKAGES[@]}"
do
    echo "checking $item, might be really slow"
    if ! brew ls --versions $item > /dev/null; then
        brew install $item
    fi
done

prompt "installing emacs"
if ! brew ls --versions emacs-plus > /dev/null ; then
    brew tap d12frosted/emacs-plus
    brew install emacs-plus\
        --with-memeplex-slim-icon\
        --with-imagemagick\
        --with-native-comp
else
    echo "emacs-plus is installed"
fi
