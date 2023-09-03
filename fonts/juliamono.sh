#!/usr/bin/env sh

FONTFILES=($(cat juliamono.txt))
TMPPATH=/tmp/JuliaMono
URL="https://github.com/cormullion/juliamono/releases/download/v0.050/JuliaMono-ttf.zip"
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
        rm -fv $(fc-list | grep -i "$FONTNAME" | awk -F ":" '{print $1}')
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
