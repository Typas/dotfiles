#!/usr/bin/env bash
set -euo pipefail

os="${1:?usage: install-tex.sh <os> <install|update> [system|home]}"
action="${2:-install}"
location="${3:-}"

usage() {
    echo "usage: install-tex.sh <os> <install|update> [system|home]" >&2
    exit 1
}

SYSTEM_PREFIX="/usr/local/texlive"
HOME_PREFIX="$HOME/.local/texlive"
SYSTEM_BIN_DIR="/usr/local/bin"
HOME_BIN_DIR="$HOME/.local/bin"
TL_BINS=(lualatex luatex pdflatex pdftex xelatex xetex tex latex tlmgr kpsewhich latexmk fmtutil-sys updmap-sys mktexlsr texhash)
TLNET_URL="https://ctan.mirror.twds.com.tw/tex-archive/systems/texlive/tlnet"

if [[ "$os" == "mac" ]]; then
    if ! command -v nix >/dev/null 2>&1; then
        echo "nix not found on PATH; install Nix first" >&2
        exit 1
    fi
    case "$action" in
        install)
            if command -v lualatex >/dev/null 2>&1; then
                echo "lualatex is already installed: $(lualatex --version | head -1)"
                exit 0
            fi
            nix profile install nixpkgs#texlive.combined.scheme-medium
            ;;
        update)
            nix profile upgrade nixpkgs#texlive.combined.scheme-medium
            ;;
        *) usage ;;
    esac
    exit 0
fi

if [[ "$os" == "cachyos" ]]; then
    pkgs=(texlive-basic texlive-latex texlive-luatex texlive-langchinese texlive-langjapanese texlive-langkorean)
    case "$action" in
        install) sudo pacman -S --needed --noconfirm "${pkgs[@]}" ;;
        update)  sudo pacman -S --noconfirm "${pkgs[@]}" ;;
        *) usage ;;
    esac
    exit 0
fi

ensure_build_deps() {
    local pkgs=(perl wget fontconfig) missing=() pkg
    case "$os" in
        fedora|opensuse*)
            for pkg in "${pkgs[@]}"; do
                rpm -q "$pkg" >/dev/null 2>&1 || missing+=("$pkg")
            done
            [[ ${#missing[@]} -eq 0 ]] && return 0
            case "$os" in
                fedora)    sudo dnf install -y "${missing[@]}" ;;
                opensuse*) sudo zypper in -y "${missing[@]}" ;;
            esac
            ;;
        ubuntu|debian)
            for pkg in "${pkgs[@]}"; do
                dpkg -s "$pkg" >/dev/null 2>&1 || missing+=("$pkg")
            done
            [[ ${#missing[@]} -eq 0 ]] && return 0
            sudo apt-get install -y "${missing[@]}"
            ;;
        *)
            echo "unsupported OS for TeX Live source install: $os" >&2
            exit 1
            ;;
    esac
}

prefix_for() {
    if [[ "$1" == "home" ]]; then echo "$HOME_PREFIX"; else echo "$SYSTEM_PREFIX"; fi
}

bin_dir_for() {
    if [[ "$1" == "home" ]]; then echo "$HOME_BIN_DIR"; else echo "$SYSTEM_BIN_DIR"; fi
}

installed_year() {
    local prefix="$1" dir latest=""
    for dir in "$prefix"/20??; do
        [[ -d "$dir" ]] || continue
        latest="$dir"
    done
    [[ -n "$latest" ]] || return 1
    basename "$latest"
}

tl_arch_bin() {
    local prefix="$1" year="$2" arch_dir latest=""
    for arch_dir in "$prefix/$year/bin/"*/; do
        [[ -d "$arch_dir" ]] || continue
        latest="${arch_dir%/}"
    done
    [[ -n "$latest" ]] || return 1
    echo "$latest"
}

link_binaries() {
    local loc="$1" arch_bin="$2" bin_dir="$3"
    local sudo_cmd=() b target
    if [[ "$loc" != "home" ]]; then
        sudo_cmd=(sudo)
    fi
    "${sudo_cmd[@]}" mkdir -p "$bin_dir"
    for b in "${TL_BINS[@]}"; do
        target="$arch_bin/$b"
        [[ -e "$target" ]] || continue
        "${sudo_cmd[@]}" ln -sf "$target" "$bin_dir/$b"
    done
}

do_install() {
    local loc="$1"
    local prefix bin_dir
    local sudo_cmd=()
    prefix="$(prefix_for "$loc")"
    bin_dir="$(bin_dir_for "$loc")"
    if [[ "$loc" != "home" ]]; then
        sudo_cmd=(sudo)
    fi

    ensure_build_deps

    local tmpdir
    tmpdir=$(mktemp -d)

    echo "downloading install-tl from $TLNET_URL..."
    curl -fsSL "$TLNET_URL/install-tl-unx.tar.gz" -o "$tmpdir/install-tl.tar.gz"
    tar -C "$tmpdir" -xzf "$tmpdir/install-tl.tar.gz"

    local installer_dir
    installer_dir=$(find "$tmpdir" -maxdepth 1 -type d -name "install-tl-*" | head -1)
    if [[ -z "$installer_dir" ]]; then
        echo "failed to locate extracted install-tl directory" >&2
        rm -rf "$tmpdir"
        exit 1
    fi

    "${sudo_cmd[@]}" mkdir -p "$prefix"

    echo "installing TeX Live scheme-basic to $prefix/<year> (repository=$TLNET_URL)..."
    "${sudo_cmd[@]}" env TEXLIVE_INSTALL_PREFIX="$prefix" "$installer_dir/install-tl" \
        -scheme scheme-basic \
        -no-interaction \
        -no-doc-install \
        -no-src-install \
        -repository "$TLNET_URL"

    rm -rf "$tmpdir"

    local year arch_bin
    year=$(installed_year "$prefix") || { echo "install-tl did not create a year dir under $prefix" >&2; exit 1; }
    arch_bin=$(tl_arch_bin "$prefix" "$year") || { echo "could not find bin dir under $prefix/$year" >&2; exit 1; }

    echo "adding LuaLaTeX collection..."
    "${sudo_cmd[@]}" "$arch_bin/tlmgr" install collection-luatex

    echo "adding CJK collections..."
    "${sudo_cmd[@]}" "$arch_bin/tlmgr" install collection-langchinese collection-langjapanese collection-langkorean

    link_binaries "$loc" "$arch_bin" "$bin_dir"

    echo "installed $("$arch_bin/lualatex" --version | head -1)"
}

do_update() {
    local loc="$1"
    local prefix bin_dir
    local sudo_cmd=()
    prefix="$(prefix_for "$loc")"
    bin_dir="$(bin_dir_for "$loc")"
    if [[ "$loc" != "home" ]]; then
        sudo_cmd=(sudo)
    fi

    local year arch_bin
    year=$(installed_year "$prefix") || { echo "TeX Live not installed at $prefix" >&2; exit 1; }
    arch_bin=$(tl_arch_bin "$prefix" "$year") || { echo "cannot find tlmgr at $prefix/$year" >&2; exit 1; }

    echo "checking TeX Live remote version ($loc, local=$year)..."
    local check_output check_rc
    set +e
    check_output=$("${sudo_cmd[@]}" "$arch_bin/tlmgr" update --self --list 2>&1)
    check_rc=$?
    set -e

    if echo "$check_output" | grep -q "Cross release updates are not supported"; then
        echo "cross-year update detected; rebuilding TeX Live ($loc)..."
        cross_year_update "$loc" "$year" "$arch_bin"
        return
    fi

    if [[ $check_rc -ne 0 ]]; then
        echo "tlmgr update --self --list failed:" >&2
        echo "$check_output" >&2
        exit $check_rc
    fi

    echo "same-year update; running tlmgr update --self --all ($loc)..."
    "${sudo_cmd[@]}" "$arch_bin/tlmgr" update --self --all
    echo "updated $("$arch_bin/lualatex" --version | head -1)"
}

cross_year_update() {
    local loc="$1" old_year="$2" old_arch_bin="$3"
    local prefix bin_dir log_file
    local sudo_cmd=()
    prefix="$(prefix_for "$loc")"
    bin_dir="$(bin_dir_for "$loc")"
    log_file="/tmp/tlmgr-installed-$loc.txt"
    if [[ "$loc" != "home" ]]; then
        sudo_cmd=(sudo)
    fi

    echo "logging installed packages to $log_file..."
    "${sudo_cmd[@]}" "$old_arch_bin/tlmgr" info --only-installed --data name > "$log_file"

    echo "removing old TeX Live $old_year at $prefix/$old_year..."
    "${sudo_cmd[@]}" rm -rf "$prefix/$old_year"

    local b target linktarget
    for b in "${TL_BINS[@]}"; do
        target="$bin_dir/$b"
        [[ -L "$target" ]] || continue
        linktarget=$(readlink "$target")
        if [[ "$linktarget" == "$prefix/$old_year"* ]]; then
            "${sudo_cmd[@]}" rm -f "$target"
        fi
    done

    do_install "$loc"

    local new_year new_arch_bin
    new_year=$(installed_year "$prefix") || { echo "new install not found under $prefix" >&2; exit 1; }
    new_arch_bin=$(tl_arch_bin "$prefix" "$new_year") || { echo "cannot find bin dir in new install" >&2; exit 1; }

    if [[ -s "$log_file" ]]; then
        local pkgs
        pkgs=$(tr '\n' ' ' < "$log_file")
        if [[ -n "${pkgs// }" ]]; then
            echo "restoring logged packages..."
            "${sudo_cmd[@]}" "$new_arch_bin/tlmgr" install $pkgs || true
        fi
        link_binaries "$loc" "$new_arch_bin" "$bin_dir"
    fi

    rm -f "$log_file"
    echo "updated $("$new_arch_bin/lualatex" --version | head -1)"
}

install_tex() {
    local loc="${location:-system}"
    local prefix
    prefix="$(prefix_for "$loc")"
    if installed_year "$prefix" >/dev/null 2>&1; then
        local year arch_bin
        year=$(installed_year "$prefix")
        arch_bin=$(tl_arch_bin "$prefix" "$year")
        echo "TeX Live already managed at $prefix/$year: $("$arch_bin/lualatex" --version | head -1)"
        exit 0
    fi
    do_install "$loc"
}

update_tex() {
    if [[ -n "$location" ]]; then
        do_update "$location"
        return
    fi
    local did_any=0
    if installed_year "$SYSTEM_PREFIX" >/dev/null 2>&1; then
        do_update system
        did_any=1
    fi
    if installed_year "$HOME_PREFIX" >/dev/null 2>&1; then
        do_update home
        did_any=1
    fi
    if [[ $did_any -eq 0 ]]; then
        echo "tex not installed; run 'just tex' first" >&2
        exit 1
    fi
}

case "$action" in
    install) install_tex ;;
    update)  update_tex ;;
    *)       usage ;;
esac
