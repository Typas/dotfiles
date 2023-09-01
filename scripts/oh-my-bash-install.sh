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

cd "$HOME" || error_exit
ln -sf "$S_LOC"/../settings-bash/.* .

cd "$LOC" || error_exit
