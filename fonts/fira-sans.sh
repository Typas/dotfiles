#!/usr/bin/env sh

FONTFILES=($(cat fira-sans.txt))
TMPPATH=/tmp/FiraSans
URL="https://github.com/bBoxType/FiraSans.git"
ZIPFILE="${URL##*/}"
FONTNAME="Fira Sans"

error_exit() {
    echo "cannot install $FONTNAME"
    exit 1
}

if [ $# -ne 1 ]; then
    echo "usage: ./fira-code.sh <in/rm>"
    error_exit
fi

download() {
    git clone --depth=1 $URL $TMPPATH || error_exit
}

extract() {
    :
}

install_font() {
    if ! fc-list | grep -i "$FONTNAME" > /dev/null; then
        if [ ! -d "$TMPPATH" ]; then
            download
            extract
        fi
        for ff in ${FONTFILES[@]}; do
            fontpath=$(find "$TMPPATH" -name "$ff")
            bash add-font-file.sh "$fontpath" || error_exit
        done
        fc-cache -f
        echo "successfully installed $FONTNAME"
    else
        echo "$FONTNAME has been installed"
    fi
}

remove_font() {
    if fc-list | grep -i "$FONTNAME" > /dev/null; then
        rm -fv $(fc-list | grep -i "$FONTNAME" | awk -F ":" '{print $1}')
        fc-cache -f
        echo "removed $FONTNAME"
    else
        echo "$FONTNAME not found"
    fi
}

case $1 in
    "in" | "install")
        install_font;;
    "rm" | "remove")
        remove_font;;
esac
