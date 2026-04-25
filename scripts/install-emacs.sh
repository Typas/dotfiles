#!/usr/bin/env bash
set -euo pipefail

os="${1:?usage: install-emacs.sh <os> <install|update> [system|home]}"
action="${2:-install}"
location="${3:-}"

usage() {
    echo "usage: install-emacs.sh <os> <install|update> [system|home]" >&2
    exit 1
}

HOME_PREFIX="$HOME/.local"
SYSTEM_BIN="/usr/local/bin/emacs"
HOME_BIN="$HOME_PREFIX/bin/emacs"

if [[ "$os" == "mac" ]]; then
    if ! command -v nix >/dev/null 2>&1; then
        echo "nix not found on PATH; install Nix first" >&2
        exit 1
    fi
    case "$action" in
        install)
            if command -v emacs >/dev/null 2>&1; then
                echo "emacs is already installed: $(emacs --version | head -1)"
                exit 0
            fi
            nix profile install nixpkgs#emacs
            ;;
        update)
            nix profile upgrade nixpkgs#emacs
            ;;
        *) usage ;;
    esac
    exit 0
fi

if [[ "$os" == "cachyos" ]]; then
    case "$action" in
        install) sudo pacman -S --needed --noconfirm emacs ;;
        update)  sudo pacman -S --noconfirm emacs ;;
        *) usage ;;
    esac
    exit 0
fi

if [[ "$os" == "opensuse-tumbleweed" ]]; then
    case "$action" in
        install) sudo zypper in -y emacs ;;
        update)  sudo zypper up -y emacs ;;
        *) usage ;;
    esac
    exit 0
fi

ensure_build_deps() {
    local pkgs=() missing=() pkg
    case "$os" in
        fedora)
            pkgs=(gcc make autoconf texinfo libgccjit-devel libtree-sitter-devel sqlite-devel gnutls-devel libxml2-devel libvterm-devel ncurses-devel zlib-devel)
            ;;
        ubuntu|debian)
            local gcc_major
            gcc_major=$(gcc -dumpversion | cut -d. -f1)
            pkgs=(build-essential autoconf texinfo "libgccjit-${gcc_major}-dev" libtree-sitter-dev libsqlite3-dev libgnutls28-dev libxml2-dev libvterm-dev libncurses-dev zlib1g-dev)
            ;;
        *)
            echo "unsupported OS for emacs source build: $os" >&2
            exit 1
            ;;
    esac

    case "$os" in
        fedora)
            for pkg in "${pkgs[@]}"; do
                rpm -q "$pkg" >/dev/null 2>&1 || missing+=("$pkg")
            done
            [[ ${#missing[@]} -eq 0 ]] && return 0
            sudo dnf install -y "${missing[@]}"
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

get_latest_tarball() {
    curl -fsSL https://ftp.gnu.org/gnu/emacs/ \
        | grep -oE 'emacs-[0-9]+\.[0-9]+(\.[0-9]+)?\.tar\.xz' \
        | sort -V -u \
        | tail -1
}

get_release_tag() {
    curl -fsSL https://api.github.com/repos/Typas/emacs-build/releases/latest \
        | grep '"tag_name"' \
        | head -1 \
        | sed -E 's/.*"tag_name"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/'
}

install_package() {
    local tag version asset url
    tag=$(get_release_tag)
    if [[ -z "$tag" ]]; then
        echo "failed to detect latest emacs release" >&2
        exit 1
    fi
    version="${tag#emacs-}"

    case "$os" in
        ubuntu|debian)
            asset="emacs-typas_${version}_${os}_amd64.deb"
            ;;
        fedora)
            asset="emacs-typas-${version}-1.x86_64.rpm"
            ;;
        *)
            echo "install_package: unsupported OS: $os" >&2
            exit 1
            ;;
    esac

    tmpfile="/tmp/${asset}"
    trap 'rm -f "$tmpfile"' EXIT
    url="https://github.com/Typas/emacs-build/releases/download/${tag}/${asset}"

    case "$os" in
        ubuntu|debian)
            echo "installing emacs ${version} (${os} package)..."
            curl -fsSL "$url" -o "$tmpfile"
            sudo apt-get install -y "$tmpfile"
            ;;
        fedora)
            echo "installing emacs ${version} (fedora package)..."
            curl -fsSL "$url" -o "$tmpfile"
            sudo dnf install -y "$tmpfile"
            ;;
    esac

    echo "installed $(emacs --version | head -1)"
}

do_build() {
    ensure_build_deps

    local tarball srcdir
    tarball=$(get_latest_tarball)
    if [[ -z "$tarball" ]]; then
        echo "failed to detect latest emacs tarball" >&2
        exit 1
    fi
    srcdir="/tmp/${tarball%.tar.xz}"

    echo "building emacs ${tarball%.tar.xz} (nox, prefix=${HOME_PREFIX})..."
    curl -fsSL "https://ftp.gnu.org/gnu/emacs/${tarball}" -o "/tmp/${tarball}"
    rm -rf "$srcdir"
    tar -C /tmp -xJf "/tmp/${tarball}"

    (
        cd "$srcdir"
        ./configure \
            "--prefix=$HOME_PREFIX" \
            --disable-build-details \
            --with-native-compilation=aot \
            --with-tree-sitter \
            --with-small-ja-dic \
            --without-included-regex \
            --without-x
        make -j"$(nproc)"
        make install
    )

    rm -rf "$srcdir" "/tmp/${tarball}"
    echo "installed $("$HOME_PREFIX/bin/emacs" --version | head -1)"
}

install_emacs() {
    if command -v emacs >/dev/null 2>&1; then
        echo "emacs is already installed: $(emacs --version | head -1)"
        exit 0
    fi
    if [[ "${location:-system}" == "home" ]]; then
        do_build
    else
        install_package
    fi
}

update_emacs() {
    if [[ -n "$location" ]]; then
        if [[ "$location" == "home" ]]; then
            do_build
        else
            install_package
        fi
        return
    fi
    local did_any=0
    if [[ -x "$SYSTEM_BIN" ]]; then
        install_package
        did_any=1
    fi
    if [[ -x "$HOME_BIN" ]]; then
        do_build
        did_any=1
    fi
    if [[ $did_any -eq 0 ]]; then
        echo "emacs not installed; run 'just emacs' first" >&2
        exit 1
    fi
}

case "$action" in
    install) install_emacs ;;
    update)  update_emacs ;;
    *)       usage ;;
esac
