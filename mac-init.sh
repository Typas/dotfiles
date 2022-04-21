#!/usr/bin/env zsh
LOCATION=$(pwd)

# install homebrew
curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash

# mac-specific
brew install wget
brew install rust-analyzer
brew tap d12frosted/emacs-plus
brew install emacs-plus --with-native-comp --with-memeplex-slim-icon

while read -r line
do
    brew install "$line"
done < "$LOCATION/package.list"

bash "$LOCATION/common-init.sh"
