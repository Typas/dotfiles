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
    #!/usr/bin/env bash
    set -euo pipefail
    if command -v juliaup &>/dev/null; then
        echo "julia has already been installed"
    else
        curl -fsSL https://install.julialang.org | sh -s -- -y
        case "{{os}}" in
            mac) source ~/.zshrc ;;
            *)   source ~/.bashrc ;;
        esac
    fi

# Install Haskell via ghcup (with required system dependencies)
haskell:
    #!/usr/bin/env bash
    set -euo pipefail
    if command -v ghcup &>/dev/null; then
        echo "haskell has already been installed"
    else
        case "{{os}}" in
            mac) ;; # Xcode command line tools covers everything
            cachyos)
                sudo pacman -S --needed --noconfirm gmp ncurses make pkg-config 2>&1 | grep -v 'is up to date -- skipping' ;;
            fedora)
                sudo dnf install -y gmp-devel ncurses-devel make pkgconfig gcc-c++ xz ;;
            opensuse*)
                sudo zypper in -y gmp-devel ncurses-devel make pkg-config gcc-c++ xz ;;
            ubuntu|debian)
                sudo apt-get install -y libgmp-dev libncurses-dev make pkg-config g++ xz-utils ;;
        esac
        curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh -s -- -y
        case "{{os}}" in
            mac) source ~/.zshrc ;;
            *)   source ~/.bashrc ;;
        esac
    fi

# Install optional fonts (Fira Sans, Inconsolata, LXGW WenKai TC)
font:
    #!/usr/bin/env bash
    set -euo pipefail
    cd fonts
    bash fira-sans.sh install
    bash inconsolata.sh install
    bash lxgw-wenkai-tc.sh install

# Install LSP servers for available languages
[group('lsp'), parallel]
lsp: _lsp-rust-analyzer _lsp-julia _lsp-gopls _lsp-hls _lsp-texlab _lsp-bash

[group('lsp'), private]
_lsp-rust-analyzer:
    #!/usr/bin/env bash
    if ! command -v rustup &>/dev/null; then echo "rustup not found, skipping rust-analyzer"
    elif command -v rust-analyzer &>/dev/null; then echo "rust-analyzer already installed"
    else rustup component add rust-analyzer; fi

[group('lsp'), private]
_lsp-julia:
    #!/usr/bin/env bash
    if ! command -v julia &>/dev/null; then echo "julia not found, skipping julia LSP"
    else julia scripts/install-lsp-julia.jl; fi

[group('lsp'), private]
_lsp-gopls:
    #!/usr/bin/env bash
    if ! command -v go &>/dev/null; then echo "go not found, skipping gopls"
    elif command -v gopls &>/dev/null; then echo "gopls already installed"
    else go install golang.org/x/tools/gopls@latest; fi

[group('lsp'), private]
_lsp-hls:
    #!/usr/bin/env bash
    if ! command -v ghcup &>/dev/null; then echo "ghcup not found, skipping hls"
    elif ghcup whereis hls &>/dev/null; then echo "hls already installed"
    else ghcup install hls; fi

[group('lsp'), private]
_lsp-texlab:
    #!/usr/bin/env bash
    if ! command -v cargo &>/dev/null; then echo "cargo not found, skipping texlab"
    elif command -v texlab &>/dev/null; then echo "texlab already installed"
    else cargo install texlab; fi

[group('lsp'), private]
_lsp-bash:
    #!/usr/bin/env bash
    if ! command -v npm &>/dev/null; then echo "npm not found, skipping bash-language-server"
    elif npm view bash-language-server &>/dev/null 2>&1; then echo "bash-language-server already installed"
    else npm i -g bash-language-server; fi

_shell-init os:
    #!/usr/bin/env bash
    set -euo pipefail
    case "{{os}}" in
        mac)                     zsh scripts/zinit-install.sh ;;
        fedora|opensuse*|cachyos|debian) bash scripts/oh-my-bash-install.sh ;;
    esac
