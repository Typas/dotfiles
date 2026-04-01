#!/usr/bin/env bash
set -euo pipefail

mapfile -t FONTFILES < juliamono.txt
TMPPATH=/tmp/JuliaMono
URL="https://github.com/cormullion/juliamono/releases/latest/download/JuliaMono-ttf.zip"
ZIPFILE="${URL##*/}"
FONTNAME="JuliaMono"

if [ $# -ne 1 ]; then
    echo "usage: ./juliamono.sh <in/rm>"
    exit 1
fi

download() {
    curl -fL --output-dir /tmp -O "$URL"
}

extract() {
    unzip -d "$TMPPATH" "/tmp/$ZIPFILE"
    rm -f "/tmp/$ZIPFILE"
}

install_font() {
    if ! fc-list | grep -i "$FONTNAME" > /dev/null; then
        if [ ! -d "$TMPPATH" ]; then
            download
            extract
        fi
        for ff in "${FONTFILES[@]}"; do
            fontpath=$(find "$TMPPATH" -name "$ff")
            if [ -n "$fontpath" ]; then
                source ./add-font-file.sh "$fontpath"
            else
                echo "font skipped: $ff"
            fi
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
            source ./remove-font-file.sh  "$ff"
        done
        rm -rf "$TMPPATH"
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
