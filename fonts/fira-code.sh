#!/usr/bin/env bash
set -euo pipefail

mapfile -t FONTFILES < fira-code.txt
TMPPATH=/tmp/FiraCode
URL="https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip"
ZIPFILE="${URL##*/}"
FONTNAME="Fira Code"

if [ $# -ne 1 ]; then
    echo "usage: ./fira-code.sh <in/rm>"
    exit 1
fi

download() {
    curl -fL --output-dir /tmp -O "$URL"
}

extract() {
    unzip -d "$TMPPATH" "/tmp/$ZIPFILE"
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
            source ./remove-font-file.sh  "$fontpath"
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
