{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # from os-init/mac-init.sh (minus gcc/openssh/curl — use system)
    fd
    dust
    eza
    editorconfig-core-c
    shellcheck
    typst
    cmake
    fontconfig
    p7zip

    # from scripts/install-modern.sh mac branch
    bat
    delta
    duf
    fzf
    mcfly
    jq
    yq-go
    sd
    tealdeer
    bottom
    gping
    hyperfine
    procs
    curlie
    xh
    zoxide
    doggo

    # from init.sh + scripts/install-wezterm.sh
    just
    wezterm
  ];
}
