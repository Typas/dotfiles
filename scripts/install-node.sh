#!/usr/bin/env bash
set -euo pipefail

# fnm's install is OS-uniform (curl | bash), so no <os> arg is needed.

# fnm (Fast Node Manager)
# --skip-shell: the installer aborts with "Could not infer shell" when $SHELL is
# unset (CI / non-interactive). Persistent shell integration lives statically in the
# repo-tracked rc files (settings-bash/.bashrc, settings-zsh/.zshrc).
if ! command -v fnm &>/dev/null; then
  curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
fi

export PATH="$HOME/.local/share/fnm:$PATH"
eval "$(fnm env)"

# Already fully set up (fnm present with Node + pnpm) — nothing to do.
if command -v pnpm &>/dev/null; then
  echo "fnm and pnpm are already installed"
  fnm --version
  node --version
  pnpm --version
  exit 0
fi

# Node LTS provides corepack, which provides pnpm
fnm install --lts
fnm use lts-latest
fnm default lts-latest

# Enable pnpm shim via corepack
corepack enable pnpm

fnm --version
node --version
pnpm --version
