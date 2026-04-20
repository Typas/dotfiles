# PATH here to avoid weird thing, .zshenv
export PATH="$HOME/.local/bin:$PATH"
if uname -a | grep Darwin > /dev/null; then
    export PATH="/Library/TeX/texbin:$PATH"
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


### zimfw
ZIM_HOME=${ZIM_HOME:-${XDG_DATA_HOME:-${HOME}/.local/share}/zim}
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
    source ${ZIM_HOME}/zimfw.zsh init -q
fi
source ${ZIM_HOME}/init.zsh
### end zimfw

# history (was OMZ::lib/history.zsh)
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000
setopt extended_history hist_expire_dups_first hist_ignore_dups hist_ignore_space \
    hist_verify inc_append_history share_history

# key bindings
bindkey "^[[A" history-substring-search-up
bindkey -M emacs "\C-p" history-substring-search-up
bindkey -M vicmd "k" history-substring-search-up
bindkey "^[[B" history-substring-search-down
bindkey -M emacs "\C-n" history-substring-search-down
bindkey -M vicmd "j" history-substring-search-down
bindkey "^[[Z" autosuggest-accept

# common profile if exists
if [ -f $HOME/.profile ]
then
    . "$HOME/.profile"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# alias
[ -f "$HOME"/.alias ] && source "$HOME"/.alias

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('"$HOME"/.local/share/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/.local/share/anaconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/.local/share/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/.local/share/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Go
export PATH="/usr/local/go/bin:$HOME/.local/go/bin:$HOME/go/bin:$PATH"

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

path=("$HOME"/.juliaup/bin $path)
export PATH

# <<< juliaup initialize <<<

[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" # ghcup-envexport PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
