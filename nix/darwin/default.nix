{ pkgs, username, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.zsh.enable = true;

  system.primaryUser = username;
  system.stateVersion = 5;

  nixpkgs.config.allowUnfree = true;
}
