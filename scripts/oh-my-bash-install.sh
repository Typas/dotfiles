#!/usr/bin/env bash
if [ ! -d "$HOME/.oh-my-bash" ]
then
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
    chsh -s "$(which bash)"
fi
