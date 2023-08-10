#!/usr/bin/env sh
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
zsh -c "$(zinit self-update)"
chsh -s "$(which zsh)"