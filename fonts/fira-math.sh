#!/usr/bin/env bash
set -euo pipefail

mapfile -t FONTFILES < fira-math.txt
TMPPATH=/tmp/FiraMath
URL="https://github.com/firamath/firamath/releases/download/v0.3.4/FiraMath-Regular.otf"
FONTNAME="Fira Math"

if [ $# -ne 1 ]; then
    echo "usage: ./fira-math.sh <in/rm>"
    exit 1
fi

download() {
    mkdir -p "$TMPPATH"
    curl -fL -o "$TMPPATH/FiraMath-Regular.otf" "$URL"
}

install_font() {
    if ! fc-list | grep -i "$FONTNAME" > /dev/null; then
        if [ ! -d "$TMPPATH" ]; then
            download
        fi
        for ff in "${FONTFILES[@]}"; do
            bash add-font-file.sh "$TMPPATH/$ff"
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
            bash remove-font-file.sh "$TMPPATH/$ff"
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
