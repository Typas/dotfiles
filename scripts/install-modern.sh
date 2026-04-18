#!/usr/bin/env bash
set -euo pipefail
os="${1:?usage: install-modern.sh <os>}"

# --- macOS: managed declaratively by nix-darwin (nix/home/packages.nix) ---
if [ "$os" = "mac" ]; then
    echo "modern tools are managed by nix-darwin; edit nix/home/packages.nix and run 'just init'"
    exit 0
fi

# --- Linux: three-tier installation ---

# Tier 1: cargo tools
if command -v cargo &>/dev/null; then
    declare -A CARGO_MAP=(
        [bat]=bat
        [dust]=du-dust
        [sd]=sd
        [hyperfine]=hyperfine
        [zoxide]=zoxide
        [btm]=bottom
        [gping]=gping
        [procs]=procs
        [xh]=xh
        [delta]=git-delta
        [mcfly]=mcfly
        [tldr]=tealdeer
    )
    CARGO_PKGS=()
    for cmd in "${!CARGO_MAP[@]}"; do
        if ! command -v "$cmd" &>/dev/null; then
            CARGO_PKGS+=("${CARGO_MAP[$cmd]}")
        fi
    done
    if (( ${#CARGO_PKGS[@]} > 0 )); then
        echo "cargo install ${CARGO_PKGS[*]}"
        cargo install "${CARGO_PKGS[@]}"
    fi
else
    echo "cargo not found, skipping cargo-based tools"
fi

# Tier 2: system package manager (jq, duf, fzf)
echo "installing system packages: jq duf fzf"
case "$os" in
    fedora)        sudo dnf install -y jq duf fzf ;;
    opensuse-tumbleweed)     sudo zypper in -y jq duf fzf ;;
    cachyos)       sudo pacman -S --needed --noconfirm jq duf fzf ;;
    debian|ubuntu) sudo apt-get install -y jq fzf ;;
esac

# Tier 3: pre-built binaries from GitHub releases (yq, doggo, curlie)
ARCH=$(uname -m)
case "$ARCH" in
    x86_64)  ARCH="amd64" ;;
    aarch64) ARCH="arm64" ;;
esac
GOOS=$(uname -s | tr '[:upper:]' '[:lower:]')

mkdir -p ~/.local/bin

install_from_github() {
    local cmd="$1" repo="$2" pattern="$3"
    if command -v "$cmd" &>/dev/null; then
        echo "$cmd is already installed"
        return
    fi
    echo "installing $cmd from $repo..."
    local url
    url=$(curl -fsSL "https://api.github.com/repos/${repo}/releases/latest" \
        | grep -o "\"browser_download_url\": *\"[^\"]*${pattern}[^\"]*\"" \
        | head -1 \
        | sed 's/"browser_download_url": *"//;s/"$//')
    if [ -z "$url" ]; then
        echo "failed to find download URL for $cmd"
        return 1
    fi
    local tmp
    tmp=$(mktemp -d)
    curl -fsSL "$url" -o "$tmp/archive"
    case "$url" in
        *.tar.gz) tar -xzf "$tmp/archive" -C "$tmp" ;;
        *.zip)    unzip -o "$tmp/archive" -d "$tmp" ;;
    esac
    local bin
    bin=$(find "$tmp" -name "$cmd" -type f | head -1)
    if [ -n "$bin" ]; then
        install -m 755 "$bin" ~/.local/bin/
        echo "installed $cmd to ~/.local/bin/"
    else
        echo "failed to find $cmd binary in release archive"
    fi
    rm -rf "$tmp"
}

install_from_github "yq" "mikefarah/yq" "yq_${GOOS}_${ARCH}.tar.gz"
install_from_github "doggo" "mr-karan/doggo" "doggo.*${GOOS}_${ARCH}.tar.gz"
install_from_github "curlie" "rs/curlie" "curlie.*${GOOS}_${ARCH}.tar.gz"
