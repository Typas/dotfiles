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
      username = builtins.getEnv "USER";
      hostname = builtins.getEnv "HOSTNAME";
      system = "aarch64-darwin";
    in
    {
      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit username; };
        modules = [
          ./nix/darwin/default.nix
          home-manager.darwinModules.home-manager
          {
            users.users.${username}.home = "/Users/${username}";

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit username; };
            home-manager.users.${username} = import ./nix/home/default.nix;
          }
        ];
      };
    };
}
