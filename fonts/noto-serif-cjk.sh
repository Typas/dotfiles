#!/usr/bin/env sh

FONTFILES=($(cat noto-serif-cjk.txt))
TMPPATH=/tmp/NotoSerifCJK
URL="https://github.com/notofonts/noto-cjk/releases/download/Serif2.002/02_NotoSerifCJK-OTF-VF.zip"
ZIPFILE="${URL##*/}"
FONTNAME="Noto Serif CJK"

error_exit() {
    echo "cannot install $FONTNAME"
    exit 1
}

if [ $# -ne 1 ]; then
    echo "usage: ./noto-serif-cjk.sh <in/rm>"
    error_exit
fi

download() {
    wget -P /tmp "$URL" || error_exit
}

extract() {
    unzip -d "$TMPPATH" "/tmp/$ZIPFILE" || error_exit
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
        for ff in ${FONTFILES[@]}; do
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
