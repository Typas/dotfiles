#!/usr/bin/env bash
set -euo pipefail
D_LOC="${D_LOC:?D_LOC must be set}"

sudo -v

prompt() {
    local available=$(($(tput cols) - ${#1} - 2))
    local left=$((available / 2))
    local right=$((available - left))

    test $left -gt 0 && printf -- "=%.0s" $(seq 1 $left)
    printf " %s " "$1"
    test $right -gt 0 && printf -- "=%.0s" $(seq 1 $right)
    echo ""
}

prompt "system package installations"
prompt "wezterm APT repo"
if [ ! -f /usr/share/keyrings/wezterm-fury.gpg ]; then
    curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
    echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
    sudo apt-get update
fi

PACKAGES=(fd-find clang flatpak gcc pkg-config libssl-dev editorconfig shellcheck openssh-client wezterm)
mapfile -t extra < "$D_LOC"/lists/package.list
PACKAGES+=("${extra[@]}")
if [[ -z "${DOTFILES_SKIP_UPDATE:-}" ]]; then
    sudo apt-get update
fi
sudo apt-get install -y "${PACKAGES[@]}"
if ! command -v fd > /dev/null 2>&1; then
    mkdir -p ~/.local/bin
    ln -sf "$(which fdfind)" ~/.local/bin/fd
    source ~/.bashrc
    source ~/.profile
fi

prompt "flatpak setup"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
