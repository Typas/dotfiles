#!/usr/bin/env bash
if uname -a | grep Darwin > /dev/null; then
    export FONT_PATH="$HOME"/Library/Fonts/
elif uname -a | grep Linux > /dev/null; then
    export FONT_PATH="$HOME"/.local/share/fonts/
else
    echo "not supported system"
    exit 1
fi

