#!/usr/bin/env bash
set -euo pipefail
D_LOC="${D_LOC:?D_LOC must be set}"

if ! command -v zinit > /dev/null; then
    bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
fi
zsh -c "$(zinit self-update)"

cd "$HOME" || error_exit
for setting in "$D_LOC"/settings-zsh/.*
do
    ln -sf "$setting" .
done
