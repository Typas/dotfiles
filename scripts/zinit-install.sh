#!/usr/bin/env bash
LOC=$(pwd)
S_LOC=$(cd -- "$(dirname -- "{BASH_SOURCE[0]}")" &> /dev/null && pwd)

error_exit() {
    echo "something's wrong, exiting"
    cd "$LOC" || exit 1
    exit 1
}

if ! command -v zinit > /dev/null; then
    bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
fi
zsh -c "$(zinit self-update)"

cd "$HOME" || error_exit
ln -sf "$S_LOC"/../settings-zsh/.* .

cd "$LOC" || error_exit
