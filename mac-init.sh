#!/usr/bin/env zsh
LOCATION=$(pwd)

# mac-specific
echo "installing homebrew"
if ! command -v brew > /dev/null; then
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
fi

brew update

echo "installing wezterm"
if ! command -v wezterm > /dev/null; then
    brew tap wez/wezterm
    brew install --cask wez/wezterm/wezterm
fi

brew install wget fd dust

brew install "$(cat "$LOCATION"/package.list)"

# common
echo "common initialization"
bash LOCATION="$LOCATION" "$LOCATION/scripts/common-init.sh"

# mac-specific
echo "installing emacs"
if true; then
    brew tap d12frosted/emacs-plus
    brew install emacs-plus\
        --with-memeplex-slim-icon\
        --with-imagemagick\
        # --with-native-comp
fi

echo "shell initialization"
bash "$LOCATION/scripts/zinit-install.sh"
ln -sf "$LOCATION/settings-zsh/.zshrc" "$HOME/.zshrc"
ln -sf "$LOCATION/settings-zsh/.p10k.zsh" "$HOME/.p10k.zsh"
ln -sf "$LOCATION/settings-zsh/.zshenv" "$HOME/.zshenv"
