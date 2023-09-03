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

echo "removing font $SRC_FILE"
rm -f "$FONT_PATH"/"$SRC_FILE"
