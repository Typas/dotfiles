#!/usr/bin/env zsh
set -euo pipefail
D_LOC="${D_LOC:?D_LOC must be set}"

ZIM_HOME=${ZIM_HOME:-${XDG_DATA_HOME:-${HOME}/.local/share}/zim}

if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
    mkdir -p "${ZIM_HOME}"
    curl -fsSL --create-dirs -o "${ZIM_HOME}/zimfw.zsh" \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

cd "$HOME"
for setting in "$D_LOC"/settings-zsh/.*
do
    [[ "${setting##*/}" == "." || "${setting##*/}" == ".." ]] && continue
    ln -sf "$setting" .
done

zsh -c "source ${ZIM_HOME}/zimfw.zsh install && source ${ZIM_HOME}/zimfw.zsh update"
