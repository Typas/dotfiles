# dotfiles setup

os := if os() == "macos" { "mac" } else { `grep "^ID=" /etc/os-release | sed 's/ID=//;s/^"//;s/"$//'` }
update := "true"

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
        *)         echo "unsupported OS: {{os}}"; exit 1 ;;
    esac

_common-init:
    cd scripts && bash common-init.sh

_shell-init os:
    #!/usr/bin/env bash
    set -euo pipefail
    case "{{os}}" in
        mac)                     zsh scripts/zinit-install.sh ;;
        fedora|opensuse*|cachyos) bash scripts/oh-my-bash-install.sh ;;
    esac
