#!/usr/bin/env bash
set -euo pipefail

mapfile -t FONTFILES < fira-sans.txt
TMPPATH=/tmp/FiraSans
BASEURL="https://raw.githubusercontent.com/bBoxType/FiraSans/master/Fira_Sans_4_3/Fonts/Fira_Sans_OTF_4301/Normal"
FONTNAME="Fira Sans"

if [ $# -ne 1 ]; then
    echo "usage: ./fira-sans.sh <in/rm>"
    exit 1
fi

download() {
    mkdir -p "$TMPPATH"
    local args=()
    for ff in "${FONTFILES[@]}"; do
        if [[ "$ff" == *Italic* ]]; then
            args+=(-o "$TMPPATH/$ff" "$BASEURL/Italic/$ff")
        else
            args+=(-o "$TMPPATH/$ff" "$BASEURL/Roman/$ff")
        fi
    done
    curl -fL --parallel "${args[@]}"
}

install_font() {
    if ! fc-list | grep -i "$FONTNAME" > /dev/null; then
        if [ ! -d "$TMPPATH" ]; then
            download
        fi
        for ff in "${FONTFILES[@]}"; do
            source ./add-font-file.sh "$TMPPATH/$ff"
        done
        echo "successfully installed $FONTNAME"
    else
        echo "$FONTNAME has been installed"
    fi
}

remove_font() {
    if fc-list | grep -i "$FONTNAME" > /dev/null; then
        for ff in "${FONTFILES[@]}"; do
            source ./remove-font-file.sh "$TMPPATH/$ff"
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
