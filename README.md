# dotfiles

Personal dotfiles managed with a `justfile` and a thin `init.sh` bootstrap script.

## Quick Start

```bash
git clone <repo-url> ~/.config/dotfiles
cd ~/.config/dotfiles
bash init.sh
```

`init.sh` updates the system package manager, installs [just](https://github.com/casey/just), and runs `just init`.

## Available Recipes

| Recipe | Description |
|--------|-------------|
| `just init` | Full setup: OS packages, Rust, cargo tools, fonts, symlinks, shell config |
| `just julia` | Install Julia via juliaup |
| `just haskell` | Install Haskell via ghcup |
| `just neovim` / `just neovim update` | Install or update Neovim (pass `home` to install under `~/.local`) |
| `just emacs` / `just emacs update` | Install or update Emacs (system build is pgtk, home build is nox) |
| `just font` | Install optional fonts (Fira Sans, Inconsolata, LXGW WenKai TC) |
| `just lsp` | Install LSP servers for available languages |
| `just help` | List all recipes |

## Supported OS Distributions

- macOS
- Fedora
- openSUSE
- CachyOS (Arch-based)
- Ubuntu

## Notes

- Install LaTeX separately; there is no consistent cross-distro install method.
- Run `just font` to install fonts listed in the `fonts/` directory.
