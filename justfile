# dotfiles setup

root := justfile_directory()

os := if os() == "macos" { "mac" } else { `grep "^ID=" /etc/os-release | sed 's/ID=//;s/^"//;s/"$//'` }
update := "false"

# Show available recipes
help:
    @just --list

# Core setup: OS packages, rust, cargo tools, fonts, symlinks, shell
init: (_os-packages os update) (_rust-setup os) (_parallel-fonts "required") _common-setup (_shell-setup os)
    @echo ""
    @echo "Done!"

_os-packages os update:
    #!/usr/bin/env bash
    set -euo pipefail
    export DOTFILES_SKIP_UPDATE={{ if update == "false" { "1" } else { "" } }}
    case "{{os}}" in
        mac)
            HOSTNAME="${HOSTNAME:-$(scutil --get LocalHostName)}"
            if command -v darwin-rebuild &>/dev/null; then
                sudo -H "$(command -v darwin-rebuild)" switch --flake "{{root}}#${HOSTNAME}"
            else
                sudo -H "$(command -v nix)" --extra-experimental-features 'nix-command flakes' \
                    run nix-darwin -- switch --flake "{{root}}#${HOSTNAME}"
            fi
            ;;
        fedora)    D_LOC="{{root}}" bash {{root}}/os-init/fedora-init.sh ;;
        opensuse-tumbleweed) D_LOC="{{root}}" bash {{root}}/os-init/opensuse-tumbleweed-init.sh ;;
        cachyos)   D_LOC="{{root}}" bash {{root}}/os-init/cachyos-init.sh ;;
        ubuntu)    D_LOC="{{root}}" bash {{root}}/os-init/ubuntu-init.sh ;;
        debian)    D_LOC="{{root}}" bash {{root}}/os-init/debian-init.sh ;;
        *)         echo "unsupported OS: {{os}}"; exit 1 ;;
    esac

_rust-setup os:
    #!/usr/bin/env bash
    set -euo pipefail
    # mac manages eza/fd/ripgrep via nix; rustup stays an opt-in per-user install.
    if [ "{{os}}" = "mac" ]; then
        exit 0
    fi
    cd {{root}}/scripts
    source ./rust-install.sh
    source ./cargo-packages.sh

_common-setup:
    #!/usr/bin/env bash
    set -euo pipefail
    cd "$HOME"
    for f in "{{root}}/home/".*; do
        name="${f##*/}"
        case "$name" in .|..) continue;; esac
        if [ -d "$name" ] && [ ! -L "$name" ]; then
            echo "skip $name (real dir)"; continue
        fi
        echo "Linking $f"
        ln -snf "$f" .
    done
    mkdir -p "$HOME/.config"
    cd "$HOME/.config"
    for d in "{{root}}/config/"*/; do
        name="$(basename "$d")"
        if [ -d "$name" ] && [ ! -L "$name" ]; then
            echo "skip $name (real dir)"; continue
        fi
        echo "Linking $d"
        ln -snf "$d" .
    done

_parallel-fonts scope:
    bash {{root}}/scripts/parallel-fonts.sh {{scope}}

_shell-setup os:
    D_LOC="{{root}}" bash {{root}}/scripts/shell-init.sh {{os}}

# Install ALL fonts (required + optional) in parallel with progress display
font:
    bash {{root}}/scripts/parallel-fonts.sh all

# Install wezterm terminal emulator
wezterm:
    bash {{root}}/scripts/install-wezterm.sh {{os}}

# Set up flatpak with flathub remote
flatpak:
    bash {{root}}/scripts/install-flatpak.sh {{os}}

# Install modern unix tools (bat, delta, dust, fzf, etc.)
modern:
    bash {{root}}/scripts/install-modern.sh {{os}}

# Install uv (Python package manager)
python:
    bash {{root}}/scripts/install-python.sh

# Install or update Go (use: just go, just go update)
go action="install":
    bash {{root}}/scripts/install-go.sh {{action}}

# Install Julia via juliaup
julia:
    bash {{root}}/scripts/install-julia.sh {{os}}

# Install Haskell via ghcup (with required system dependencies)
haskell:
    bash {{root}}/scripts/install-haskell.sh {{os}}

# Install LSP servers for available languages
lsp:
    bash {{root}}/scripts/install-lsp.sh

# Install or update TeX Live with LuaLaTeX + CJK (use: just tex, just tex update, just tex install home)
tex action="install" location="system":
    bash {{root}}/scripts/install-tex.sh {{os}} {{action}} {{location}}

# Install or update Typst (use: just typst, just typst update)
typst action="install":
    bash {{root}}/scripts/install-typst.sh {{os}} {{action}}

# Comment out cicku.me mirrors in pacman mirrorlists (idempotent; CachyOS/arch-like only)
pacman-mask-cicku:
    bash {{root}}/scripts/pacman-mask-cicku.sh {{os}}

# Install or update Emacs (use: just emacs, just emacs update, just emacs install home)
emacs action="install" location="system":
    bash {{root}}/scripts/install-emacs.sh {{os}} {{action}} {{location}}

# Install or update Neovim (use: just neovim, just neovim update, just neovim install home)
neovim action="install" location="system":
    bash {{root}}/scripts/install-neovim.sh {{os}} {{action}} {{location}}

alias nvim := neovim
