#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC2207
FONTFILES=($(cat typas-mono-cjk-tc.txt))
TMPPATH=/tmp/TypasMonoCJKTC
URL="https://github.com/Typas/Typas-Font/releases/latest/download/Typas-Mono-CJK-TC.zip"
ZIPFILE="${URL##*/}"
FONTNAME="Typas Mono CJK TC"

if [ $# -ne 1 ]; then
    echo "usage: ./typas-mono-cjk-tc.sh <in/rm>"
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
