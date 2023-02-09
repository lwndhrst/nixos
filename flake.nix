{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;

    in {
      nixosConfigurations = {
        leon = lib.nixosSystem {
          inherit system;
          modules = [ ./configuration.nix ];
        };
      };

      hmConfigurations = {
        leon = home-manager.lib.homeManagerConfiguration {
          inherit system pkgs;
          username = "leon";
          homeDirectory = "/home/leon";
          configuration = {
            imports = [ ./home.nix ];
          };
        };
      };
    };
}
