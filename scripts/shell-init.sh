#!/usr/bin/env bash
set -euo pipefail

os="${1:?usage: shell-init.sh <os>}"

case "$os" in
    mac)                             zsh "$(dirname "$0")/zinit-install.sh" ;;
    fedora|opensuse*|cachyos|debian) bash "$(dirname "$0")/oh-my-bash-install.sh" ;;
esac
