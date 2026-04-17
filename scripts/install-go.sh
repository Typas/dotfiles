#!/usr/bin/env bash
set -euo pipefail
action="${1:-install}"

GO_INSTALL_DIR="/usr/local/go"

get_latest_version() {
    curl -fsSL "https://go.dev/VERSION?m=text" | head -1
}

do_install() {
    local version
    version=$(get_latest_version)
    local arch
    arch=$(uname -m)
    case "$arch" in
        x86_64)  arch="amd64" ;;
        aarch64) arch="arm64" ;;
    esac
    local goos
    goos=$(uname -s | tr '[:upper:]' '[:lower:]')
    local url="https://go.dev/dl/${version}.${goos}-${arch}.tar.gz"

    echo "installing ${version}..."
    curl -fsSL "$url" -o /tmp/go.tar.gz
    sudo rm -rf "$GO_INSTALL_DIR"
    sudo tar -C /usr/local -xzf /tmp/go.tar.gz
    rm /tmp/go.tar.gz
    echo "installed $(${GO_INSTALL_DIR}/bin/go version)"
}

install_go() {
    if command -v go &>/dev/null; then
        echo "go is already installed: $(go version)"
        exit 0
    fi
    do_install
}

update_go() {
    echo "removing existing go installation..."
    sudo rm -rf "$GO_INSTALL_DIR"
    do_install
}

case "$action" in
    install) install_go ;;
    update)  update_go ;;
    *)       echo "usage: install-go.sh [install|update]"; exit 1 ;;
esac
