#!/usr/bin/env zsh
LOCATION=$(pwd)

# mac-specific
echo "installing homebrew"
if ! command -v brew &> /dev/null; then
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
fi

echo "installing wezterm"
if ! command -v wezterm &> /dev/null; then
    brew tap wez/wezterm
    brew install --cask wez/wezterm/wezterm
fi

echo "installing wget"
if ! command -v wget &> /dev/null; then
    brew install wget
fi

while read -r line
do
    echo "installing $line..."
    brew install "$line"
done < "$LOCATION/package.list"

# common
echo "common initialization"
bash "$LOCATION/common-init.sh"

echo "installing rust-analyzer"
brew install rust-analyzer

# mac-specific
echo "installing emacs"
if true; then
    brew tap d12frosted/emacs-plus
    brew install emacs-plus\
        --with-native-comp\
        --with-memeplex-slim-icon\
        --with-imagemagick
fi
