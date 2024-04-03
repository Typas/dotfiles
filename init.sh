#!/usr/bin/env bash
LOC=$(pwd)
D_LOC=$(cd -- "$(dirname -- "{BASH_SOURCE[0]}")" &> /dev/null && pwd)
OS="unknown"

error_exit() {
    echo "something's wrong, exiting"
    cd "$LOC" || exit 1
    exit 1
}

prompt() {
    local available=$(($(tput cols) - ${#1} - 2))
    local left=$((available / 2))
    local right=$((available - left))

    test $left -gt 0 && printf -- "=%.0s" $(seq 1 $left)
    printf " %s " "$1"
    test $right -gt 0 && printf -- "=%.0s" $(seq 1 $right)
    echo ""
}

cd "$D_LOC" || error_exit

# find os name
KERNEL=$(uname -s)
case $KERNEL in
    Darwin)
        OS=mac ;;
    Linux)
        OS="$(grep "^ID=" /etc/os-release | sed "s/ID=//g" | sed 's/^"//g' | sed 's/"$//g')" ;;
    *)
        echo "not supported system"
        error_exit
esac

prompt "os-specific initialization"
###################################
case "$OS" in
    mac)
        zsh os-init/mac-init.sh || error_exit ;;
    fedora)
        bash os-init/fedora-init.sh || error_exit ;;
    opensuse*)
        bash os-init/opensuse-init.sh || error_exit ;;
    *)
        echo "not supported system"
        error_exit
esac

prompt "common initialization"
##############################
cd scripts/ || error_exit
bash common-init.sh || error_exit

prompt "shell initialization"
#############################
case "$OS" in
    mac)
        zsh zinit-install.sh || error_exit ;;
    fedora | opensuse*)
        bash oh-my-bash-install.sh || error_exit ;;
esac

#######
echo ""
echo "Done!"
cd "$LOC" || error_exit
