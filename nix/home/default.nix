{ pkgs, username, ... }:

{
  imports = [ ./packages.nix ];

  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
}
