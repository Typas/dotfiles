#!/usr/bin/env bash
set -euo pipefail

os="${1:?usage: install-emacs.sh <os> <install|update> [system|home]}"
action="${2:-install}"
location="${3:-}"

usage() {
    echo "usage: install-emacs.sh <os> <install|update> [system|home]" >&2
    exit 1
}

SYSTEM_PREFIX="/usr/local"
HOME_PREFIX="$HOME/.local"
SYSTEM_BIN="$SYSTEM_PREFIX/bin/emacs"
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
    local flavor="$1"
    local base_pkgs=() extra_pkgs=() pkgs=() missing=() pkg
    case "$os" in
        fedora)
            base_pkgs=(gcc make autoconf texinfo libgccjit-devel libtree-sitter-devel sqlite-devel gnutls-devel libxml2-devel libvterm-devel ncurses-devel zlib-devel)
            extra_pkgs=(gtk3-devel harfbuzz-devel ImageMagick-devel)
            ;;
        ubuntu|debian)
            local gcc_major
            gcc_major=$(gcc -dumpversion | cut -d. -f1)
            base_pkgs=(build-essential autoconf texinfo "libgccjit-${gcc_major}-dev" libtree-sitter-dev libsqlite3-dev libgnutls28-dev libxml2-dev libvterm-dev libncurses-dev zlib1g-dev)
            extra_pkgs=(libgtk-3-dev libharfbuzz-dev libmagickwand-dev)
            ;;
        *)
            echo "unsupported OS for emacs source build: $os" >&2
            exit 1
            ;;
    esac

    pkgs=("${base_pkgs[@]}")
    if [[ "$flavor" == "pgtk" ]]; then
        pkgs+=("${extra_pkgs[@]}")
    fi

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
    version="${tag#v}"

    case "$os" in
        ubuntu|debian)
            asset="emacs-typas_${version}_${os}_amd64.deb"
            url="https://github.com/Typas/emacs-build/releases/download/${tag}/${asset}"
            echo "installing emacs ${version} (${os} package)..."
            curl -fsSL "$url" -o "/tmp/${asset}"
            sudo apt-get install -y "/tmp/${asset}"
            rm -f "/tmp/${asset}"
            ;;
        fedora)
            asset="emacs-typas-${version}-1.x86_64.rpm"
            url="https://github.com/Typas/emacs-build/releases/download/${tag}/${asset}"
            echo "installing emacs ${version} (fedora package)..."
            curl -fsSL "$url" -o "/tmp/${asset}"
            sudo dnf install -y "/tmp/${asset}"
            rm -f "/tmp/${asset}"
            ;;
        *)
            echo "install_package: unsupported OS: $os" >&2
            exit 1
            ;;
    esac

    echo "installed $(emacs --version | head -1)"
}

do_build() {
    local loc="$1"
    local prefix flavor
    local sudo_cmd=()
    if [[ "$loc" == "home" ]]; then
        prefix="$HOME_PREFIX"
        flavor="nox"
    else
        prefix="$SYSTEM_PREFIX"
        flavor="pgtk"
        sudo_cmd=(sudo)
    fi

    ensure_build_deps "$flavor"

    local tarball srcdir
    tarball=$(get_latest_tarball)
    if [[ -z "$tarball" ]]; then
        echo "failed to detect latest emacs tarball" >&2
        exit 1
    fi
    srcdir="/tmp/${tarball%.tar.xz}"

    echo "building emacs ${tarball%.tar.xz} (${flavor}, prefix=${prefix})..."
    curl -fsSL "https://ftp.gnu.org/gnu/emacs/${tarball}" -o "/tmp/${tarball}"
    rm -rf "$srcdir"
    tar -C /tmp -xJf "/tmp/${tarball}"

    local shared_flags=(
        "--prefix=$prefix"
        --with-native-compilation
        --with-tree-sitter
        --with-sqlite3
        --with-modules
        --enable-link-time-optimization
    )
    local flavor_flags=()
    if [[ "$flavor" == "pgtk" ]]; then
        flavor_flags=(--with-pgtk --with-harfbuzz --with-imagemagick)
    else
        flavor_flags=(--without-x)
    fi

    (
        cd "$srcdir"
        ./configure "${shared_flags[@]}" "${flavor_flags[@]}"
        make -j"$(nproc)"
        "${sudo_cmd[@]}" make install
    )

    rm -rf "$srcdir" "/tmp/${tarball}"
    echo "installed $("$prefix/bin/emacs" --version | head -1)"
}

install_emacs() {
    if command -v emacs >/dev/null 2>&1; then
        echo "emacs is already installed: $(emacs --version | head -1)"
        exit 0
    fi
    do_build "${location:-system}"
}

update_emacs() {
    if [[ -n "$location" ]]; then
        do_build "$location"
        return
    fi
    local did_any=0
    if [[ -x "$SYSTEM_BIN" ]]; then
        do_build system
        did_any=1
    fi
    if [[ -x "$HOME_BIN" ]]; then
        do_build home
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
