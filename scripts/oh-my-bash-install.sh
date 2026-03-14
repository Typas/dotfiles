#!/usr/bin/env bash
set -euo pipefail
D_LOC="${D_LOC:?D_LOC must be set}"

if [ ! -d "$HOME/.oh-my-bash" ]
then
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
fi

if [ ! -d "$HOME/.local/share/blesh" ]; then
    git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git /tmp/ble.sh
    make -C /tmp/ble.sh install PREFIX="$HOME/.local"
    rm -rf /tmp/ble.sh
fi

cd "$HOME" || error_exit
for setting in "$D_LOC"/settings-bash/.*
do
    ln -sf "$setting" .
done
