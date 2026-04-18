{
  description = "Typas's dotfiles — macOS declarative config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ... }:
    let
      system = "aarch64-darwin";
      lib = nixpkgs.lib;

      hostsDir = ./hosts;
      hosts = lib.attrNames
        (lib.filterAttrs (_: t: t == "directory") (builtins.readDir hostsDir));

      mkDarwin = hostname: nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit hostname; };
        modules = [
          ./nix/darwin/default.nix
          home-manager.darwinModules.home-manager
          (hostsDir + "/${hostname}")
        ];
      };
    in
    {
      darwinConfigurations = lib.genAttrs hosts mkDarwin;
    };
}
