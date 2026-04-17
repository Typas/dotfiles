#!/usr/bin/env bash
set -euo pipefail

mapfile -t FONTFILES < inconsolata.txt
TMPPATH=/tmp/inconsolata
URL="https://github.com/googlefonts/Inconsolata/releases/download/v3.000/Inconsolata-VF.ttf"
FONTNAME="Inconsolata"

if [ $# -ne 1 ]; then
    echo "usage: ./inconsolata.sh <in/rm>"
    exit 1
fi

download() {
    mkdir -p "$TMPPATH"
    curl -fL --output-dir "$TMPPATH" -O "$URL"
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
            source ./add-font-file.sh "$fontpath"
        done
        echo "successfully installed $FONTNAME"
    else
        echo "$FONTNAME has been installed"
    fi
}

remove_font() {
    if fc-list | grep -i "$FONTNAME" > /dev/null; then
        for ff in "${FONTFILES[@]}"; do
            fontpath=$(find "$TMPPATH" -name "$ff")
            source ./remove-font-file.sh  "$fontpath"
        done
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
