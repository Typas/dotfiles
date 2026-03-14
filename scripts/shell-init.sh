#!/usr/bin/env bash
set -euo pipefail

D_LOC="${D_LOC:?D_LOC must be set}"
os="${1:?usage: shell-init.sh <os>}"

case "$os" in
    mac)                             export D_LOC; zsh "$D_LOC/scripts/zinit-install.sh" ;;
    fedora|opensuse*|cachyos|debian) export D_LOC; bash "$D_LOC/scripts/oh-my-bash-install.sh" ;;
esac
