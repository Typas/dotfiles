#!/usr/bin/env zsh
LOCATION=$(pwd)

# install homebrew
if ! command -v brew &> /dev/null; then
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
fi

# mac-specific
if ! command -v wget &> /dev/null; then
    brew install wget
fi

while read -r line
do
    brew install "$line"
done < "$LOCATION/package.list"

# common
bash "$LOCATION/common-init.sh"

# mac-specific
if true; then
    brew tap d12frosted/emacs-plus
    brew install emacs-plus --with-native-comp --with-memeplex-slim-icon
fi
