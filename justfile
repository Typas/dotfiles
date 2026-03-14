# dotfiles setup

os := if os() == "macos" { "mac" } else { `grep "^ID=" /etc/os-release | sed 's/ID=//;s/^"//;s/"$//'` }
update := "true"

# Show available recipes
help:
    @just --list

# Full system setup: OS packages, rust, cargo tools, fonts, symlinks, and shell config
init: (_os-init os update) _common-init (_shell-init os)
    @echo ""
    @echo "Done!"

_os-init os update:
    #!/usr/bin/env bash
    set -euo pipefail
    export DOTFILES_SKIP_UPDATE={{ if update == "false" { "1" } else { "" } }}
    case "{{os}}" in
        mac)       zsh os-init/mac-init.sh ;;
        fedora)    bash os-init/fedora-init.sh ;;
        opensuse*) bash os-init/opensuse-init.sh ;;
        cachyos)   bash os-init/cachyos-init.sh ;;
        ubuntu)    bash os-init/ubuntu-init.sh ;;
        debian)    bash os-init/debian-init.sh ;;
        *)         echo "unsupported OS: {{os}}"; exit 1 ;;
    esac

_common-init:
    cd scripts && bash common-init.sh

# Install Julia via juliaup
julia:
    bash scripts/install-julia.sh {{os}}

# Install Haskell via ghcup (with required system dependencies)
haskell:
    bash scripts/install-haskell.sh {{os}}

# Install optional fonts (Fira Sans, Inconsolata, LXGW WenKai TC)
font:
    bash scripts/install-fonts.sh

# Install LSP servers for available languages
lsp:
    bash scripts/install-lsp.sh

_shell-init os:
    bash scripts/shell-init.sh {{os}}
