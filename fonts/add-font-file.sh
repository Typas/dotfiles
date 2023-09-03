#!/usr/bin/env sh

if [ $# -ne 1 ]; then
    echo "not valid input"
    exit 1
fi

SRC_PATH="$1"
SRC_FILE="${SRC_PATH##*/}"

if uname -a | grep Darwin > /dev/null; then
    FONT_PATH="$HOME"/Library/Fonts/
elif uname -a | grep Linux > /dev/null; then
    FONT_PATH="$HOME"/.local/share/fonts/
else
    echo "not supported system"
    exit 1
fi

if [ ! -d "$FONT_PATH" ]; then
    mkdir -p "$FONT_PATH"
fi

echo "adding font $SRC_FILE"
cp "$SRC_PATH" "$FONT_PATH"/"$SRC_FILE"
