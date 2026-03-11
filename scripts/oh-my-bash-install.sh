#!/usr/bin/env bash
LOC=$(pwd)
S_LOC=$(cd -- "$(dirname -- "{BASH_SOURCE[0]}")" &> /dev/null && pwd)

error_exit() {
    echo "something's wrong, exiting"
    cd "$LOC" || exit 1
    exit 1
}

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
for setting in "$S_LOC"/../settings-bash/.*
do
    ln -sf $setting .
done

cd "$LOC" || error_exit
