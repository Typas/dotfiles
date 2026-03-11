#!/usr/bin/env bash

mapfile -t FONTFILES < inconsolata.txt
TMPPATH=/tmp/inconsolata
URL="https://github.com/googlefonts/Inconsolata/releases/download/v3.000/Inconsolata-VF.ttf"
FONTNAME="Inconsolata"

error_exit() {
    echo "cannot install $FONTNAME"
    exit 1
}

if [ $# -ne 1 ]; then
    echo "usage: ./inconsolata.sh <in/rm>"
    error_exit
fi

download() {
    mkdir -p "$TMPPATH"
    curl -fL --output-dir "$TMPPATH" -O "$URL" || error_exit
}

extract() {
    : # nop
}

install_font() {
    if ! fc-list | grep -i "$FONTNAME" > /dev/null; then
        if [ ! -d "$TMPPATH" ]; then
            download
            extract
        fi
        for ff in "${FONTFILES[@]}"; do
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
        for ff in "${FONTFILES[@]}"; do
            fontpath=$(find "$TMPPATH" -name "$ff")
            bash remove-font-file.sh  "$fontpath" || error_exit
        done
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
