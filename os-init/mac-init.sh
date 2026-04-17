#!/usr/bin/env zsh
set -euo pipefail
D_LOC="${D_LOC:?D_LOC must be set}"

prompt() {
    local available=$(($(tput cols) - ${#1} - 2))
    local left=$((available / 2))
    local right=$((available - left))

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

if [[ -z "${DOTFILES_SKIP_UPDATE:-}" ]]; then
    prompt "updating homebrew"
    brew update
fi

prompt "installing packages"
PACKAGES=(fd dust eza editorconfig shellcheck typst openssh gcc cmake curl fontconfig p7zip)
for item in "${PACKAGES[@]}"
do
    echo "checking $item, might be really slow"
    if ! brew ls --versions $item > /dev/null; then
        brew install $item
    fi
done
