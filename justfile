# dotfiles setup

root := justfile_directory()

os := if os() == "macos" { "mac" } else { `grep "^ID=" /etc/os-release | sed 's/ID=//;s/^"//;s/"$//'` }
update := "true"

# Show available recipes
help:
    @just --list

# Full system setup: OS packages, rust, cargo tools, fonts, symlinks, and shell config
init: (_os-packages os update) _common-init (_shell-setup os)
    @echo ""
    @echo "Done!"

_os-packages os update:
    #!/usr/bin/env bash
    set -euo pipefail
    export DOTFILES_SKIP_UPDATE={{ if update == "false" { "1" } else { "" } }}
    case "{{os}}" in
        mac)       D_LOC="{{root}}" zsh {{root}}/os-init/mac-init.sh ;;
        fedora)    D_LOC="{{root}}" bash {{root}}/os-init/fedora-init.sh ;;
        opensuse*) D_LOC="{{root}}" bash {{root}}/os-init/opensuse-init.sh ;;
        cachyos)   D_LOC="{{root}}" bash {{root}}/os-init/cachyos-init.sh ;;
        ubuntu)    D_LOC="{{root}}" bash {{root}}/os-init/ubuntu-init.sh ;;
        debian)    D_LOC="{{root}}" bash {{root}}/os-init/debian-init.sh ;;
        *)         echo "unsupported OS: {{os}}"; exit 1 ;;
    esac

_common-init:
    cd {{root}}/scripts && D_LOC="{{root}}" bash common-init.sh

# Install Julia via juliaup
julia:
    bash {{root}}/scripts/install-julia.sh {{os}}

# Install Haskell via ghcup (with required system dependencies)
haskell:
    bash {{root}}/scripts/install-haskell.sh {{os}}

# Install optional fonts (Fira Sans, Inconsolata, LXGW WenKai TC)
font:
    bash {{root}}/scripts/install-fonts.sh

# Install LSP servers for available languages
lsp:
    bash {{root}}/scripts/install-lsp.sh

_shell-setup os:
    D_LOC="{{root}}" bash {{root}}/scripts/shell-init.sh {{os}}
