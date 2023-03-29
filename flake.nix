{
  description = "Personal NixOS configuration";

  inputs = {
    nixpkgs ={
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR"; # Nix User Repository
    };

    nix-neovim-plugins = {
      url = "github:NixNeovim/NixNeovimPlugins";
    };
  };

  outputs = inputs @ { self, nixpkgs, home-manager, nur, nix-neovim-plugins, ... }:
    let
      user = "leon";
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          nix-neovim-plugins.overlays.default
        ];
      };
      config = pkgs.config;
      lib = nixpkgs.lib;

    in {
      nixosConfigurations = (
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit system nixpkgs pkgs config home-manager nur user;
        }
      );
    };
}
