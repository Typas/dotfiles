#!/usr/bin/env sh

if [ $# -ne 1 ]; then
    echo "not valid input"
    exit 1
fi

SRC_PATH="$1"
SRC_FILE="${SRC_PATH##*/}"
. font-path.sh

if [ ! -d "$FONT_PATH" ]; then
    mkdir -p "$FONT_PATH"
fi

echo "adding font $SRC_FILE"
cp "$SRC_PATH" "$FONT_PATH"/"$SRC_FILE"
