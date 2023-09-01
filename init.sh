#!/usr/bin/env bash
LOC=$(pwd)
D_LOC=$(cd -- "$(dirname -- "{BASH_SOURCE[0]}")" &> /dev/null && pwd)
OS="unknown"

error_exit() {
    echo "something's wrong, exiting"
    cd "$LOC" || exit 1
    exit 1
}

cd "$D_LOC" || error_exit

# find os name
if uname -a | grep Darwin > /dev/null; then
    OS="mac"
elif uname -a | grep Linux > /dev/null; then
    OS="$(grep "^ID" /etc/os-release | sed "s/ID=//g")"
fi

# os-specific initialization
echo "os-specific initialization"
case "$OS" in
    mac)
        zsh os-init/mac-init.sh || error_exit ;;
    fedora | opensuse)
        bash os-init/"$OS"-init.sh || error_exit ;;
    *)
        echo "not supported system"
        error_exit
esac

############################
echo "common initialization"
cd scripts/ || error_exit
bash common-init.sh || error_exit

echo "shell initialization"
case "$OS" in
    mac)
        zsh zinit-install.sh || error_exit ;;
    fedora | opensuse)
        bash oh-my-bash-install.sh || error_exit ;;
esac
echo ""
echo "Done!"
cd "$LOC" || error_exit
