#!/usr/bin/env bash

mapfile -t FONTFILES < juliamono.txt
TMPPATH=/tmp/JuliaMono
URL="https://github.com/cormullion/juliamono/releases/latest/download/JuliaMono-ttf.zip"
ZIPFILE="${URL##*/}"
FONTNAME="JuliaMono"

error_exit() {
    echo "cannot install $FONTNAME"
    exit 1
}

if [ $# -ne 1 ]; then
    echo "usage: ./juliamono.sh <in/rm>"
    error_exit
fi

download() {
    curl -fL --output-dir /tmp -O "$URL" || error_exit
}

extract() {
    unzip -d "$TMPPATH" "/tmp/$ZIPFILE" || error_exit
    rm -f "/tmp/$ZIPFILE"
}

install_font() {
    if ! fc-list | grep -i "$FONTNAME" > /dev/null; then
        if [ ! -d "$TMPPATH" ]; then
            download || error_exit
            extract || error_exit
        fi
        for ff in "${FONTFILES[@]}"; do
            fontpath=$(find "$TMPPATH" -name "$ff")
            if [ -n "$fontpath" ]; then
                bash add-font-file.sh "$fontpath" || error_exit
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
            bash remove-font-file.sh  "$ff" || error_exit
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
