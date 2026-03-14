#!/usr/bin/env bash
set -euo pipefail

mapfile -t FONTFILES < fira-sans.txt
TMPPATH=/tmp/FiraSans
URL="https://bboxtype.com/downloads/Fira/Download_Folder_FiraSans_4301.zip"
ZIPFILE="${URL##*/}"
FONTNAME="Fira Sans"

if [ $# -ne 1 ]; then
    echo "usage: ./fira-sans.sh <in/rm>"
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
            bash add-font-file.sh "$fontpath"
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
            bash remove-font-file.sh  "$fontpath"
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
