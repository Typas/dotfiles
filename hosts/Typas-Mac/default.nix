{ ... }:

let
  username = "typas";
in
{
  _module.args.username = username;

  users.users.${username}.home = "/Users/${username}";

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit username; };
  home-manager.users.${username} = import ../../nix/home/default.nix;
}
