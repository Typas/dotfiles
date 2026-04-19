#!/usr/bin/env bash
set -euo pipefail
D_LOC="${D_LOC:?D_LOC must be set}"

sudo -v

#shellcheck disable=SC2004
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
PACKAGES=(fd-find ripgrep clang editorconfig ShellCheck openssh-clients openssl-devel pkg-config gcc cmake curl fontconfig p7zip)
# eza packaging on Fedora is inconsistent across releases; only add it if
# the active repos actually expose it, otherwise leave it for cargo-binstall.
if dnf info eza &>/dev/null; then
    PACKAGES+=(eza)
fi
if [[ -z "${DOTFILES_SKIP_UPDATE:-}" ]]; then
    sudo dnf makecache
fi
sudo dnf install -y "${PACKAGES[@]}"

# probe: verify bootstrap/fedora scope (pass case)
