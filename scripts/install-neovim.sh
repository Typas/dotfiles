#!/usr/bin/env bash
set -euo pipefail

os="${1:?usage: install-neovim.sh <os> <install|update> [system|home]}"
action="${2:-install}"
location="${3:-}"

usage() {
    echo "usage: install-neovim.sh <os> <install|update> [system|home]" >&2
    exit 1
}

SYSTEM_DIR="/opt/nvim"
SYSTEM_LINK="/usr/local/bin/nvim"
HOME_DIR="$HOME/.local/nvim"
HOME_LINK="$HOME/.local/bin/nvim"

if [[ "$os" == "mac" ]]; then
    if ! command -v nix >/dev/null 2>&1; then
        echo "nix not found on PATH; install Nix first" >&2
        exit 1
    fi
    case "$action" in
        install)
            if command -v nvim >/dev/null 2>&1; then
                echo "nvim is already installed: $(nvim --version | head -1)"
                exit 0
            fi
            nix profile install nixpkgs#neovim
            ;;
        update)
            nix profile upgrade nixpkgs#neovim
            ;;
        *) usage ;;
    esac
    exit 0
fi

if [[ "$os" == "cachyos" ]]; then
    case "$action" in
        install) sudo pacman -S --needed --noconfirm neovim ;;
        update)  sudo pacman -S --noconfirm neovim ;;
        *) usage ;;
    esac
    exit 0
fi

ensure_runtime_deps() {
    local pkgs=() missing=() pkg
    case "$os" in
        fedora)        pkgs=(luajit gettext-libs fontconfig) ;;
        opensuse-tumbleweed)     pkgs=(luajit gettext-runtime fontconfig) ;;
        ubuntu|debian) pkgs=(libluajit-5.1-2 gettext fontconfig) ;;
        *)             return 0 ;;
    esac

    case "$os" in
        fedora|opensuse-tumbleweed)
            for pkg in "${pkgs[@]}"; do
                rpm -q "$pkg" >/dev/null 2>&1 || missing+=("$pkg")
            done
            [[ ${#missing[@]} -eq 0 ]] && return 0
            case "$os" in
                fedora)    sudo dnf install -y "${missing[@]}" ;;
                opensuse-tumbleweed) sudo zypper in -y "${missing[@]}" ;;
            esac
            ;;
        ubuntu|debian)
            for pkg in "${pkgs[@]}"; do
                dpkg -s "$pkg" >/dev/null 2>&1 || missing+=("$pkg")
            done
            [[ ${#missing[@]} -eq 0 ]] && return 0
            sudo apt-get install -y "${missing[@]}"
            ;;
    esac
}

detect_asset() {
    local sys arch
    sys=$(uname -s)
    case "$sys" in
        Linux)  sys="linux" ;;
        Darwin) sys="macos" ;;
    esac
    arch=$(uname -m)
    case "$arch" in
        aarch64) arch="arm64" ;;
    esac
    echo "nvim-${sys}-${arch}"
}

get_latest_version() {
    curl -fsSL https://api.github.com/repos/neovim/neovim/releases/latest \
        | grep '"tag_name"' \
        | head -1 \
        | sed -E 's/.*"tag_name"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/'
}

do_install() {
    local loc="$1"
    local install_dir bin_link
    local sudo_cmd=()
    if [[ "$loc" == "home" ]]; then
        install_dir="$HOME_DIR"
        bin_link="$HOME_LINK"
    else
        install_dir="$SYSTEM_DIR"
        bin_link="$SYSTEM_LINK"
        sudo_cmd=(sudo)
    fi

    ensure_runtime_deps

    local asset version url tmpdir
    asset=$(detect_asset)
    version=$(get_latest_version)
    url="https://github.com/neovim/neovim/releases/download/${version}/${asset}.tar.gz"

    echo "installing neovim ${version} (${loc}) to ${install_dir}..."
    curl -fsSL "$url" -o /tmp/nvim.tar.gz

    tmpdir=$(mktemp -d)
    tar -C "$tmpdir" -xzf /tmp/nvim.tar.gz

    "${sudo_cmd[@]}" rm -rf "$install_dir"
    "${sudo_cmd[@]}" mkdir -p "$(dirname "$install_dir")"
    "${sudo_cmd[@]}" mv "$tmpdir/$asset" "$install_dir"
    rm -rf "$tmpdir" /tmp/nvim.tar.gz

    "${sudo_cmd[@]}" mkdir -p "$(dirname "$bin_link")"
    "${sudo_cmd[@]}" ln -sf "$install_dir/bin/nvim" "$bin_link"

    echo "installed $("$install_dir/bin/nvim" --version | head -1)"

    if ldd "$install_dir/bin/nvim" 2>/dev/null | grep -q "not found"; then
        echo "warning: some shared libraries are missing:" >&2
        ldd "$install_dir/bin/nvim" | grep "not found" >&2
    fi
}

install_nvim() {
    if command -v nvim >/dev/null 2>&1; then
        echo "nvim is already installed: $(nvim --version | head -1)"
        exit 0
    fi
    do_install "${location:-system}"
}

update_nvim() {
    if [[ -n "$location" ]]; then
        do_install "$location"
        return
    fi
    local did_any=0
    if [[ -x "$SYSTEM_DIR/bin/nvim" ]]; then
        do_install system
        did_any=1
    fi
    if [[ -x "$HOME_DIR/bin/nvim" ]]; then
        do_install home
        did_any=1
    fi
    if [[ $did_any -eq 0 ]]; then
        echo "nvim not installed; run 'just neovim' first" >&2
        exit 1
    fi
}

case "$action" in
    install) install_nvim ;;
    update)  update_nvim ;;
    *)       usage ;;
esac
