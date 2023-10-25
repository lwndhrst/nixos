# Personal NixOS Config


## Setup as NixOS configuration

Available hosts:
- desktop
- laptop
- vbox

### Fresh installation

```
git clone https://github.com/lwndhrst/nixos-config /mnt/etc/nixos
```
Make sure to replace `/mnt/etc/nixos/hosts/<host>/hardware-configuration.nix` with an appropriate one for your system (see: `nixos-generate-config`).
```
sudo nixos-install --flake /mnt/etc/nixos#<host>
```

### Rebuild

Make sure to `git add` new files before rebuilding as they will be ignored otherwise.
```
sudo nixos-rebuild switch --flake /etc/nixos#<host>
```

### Update flake from within the flake dir

```
nix flake update
```


## Setup with standalone Home Manager

Available hosts:
- desktop
- laptop
- vbox
- wsl

### For non-NixOS Systems

Install nix via the [Determinate Nix Installer](https://github.com/DeterminateSystems/nix-installer).
```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install linux --init none
```
Note: you may need to install a few extra packages, such as `curl` or `git`.

### Initial setup of [Home Manager with Flakes](https://nix-community.github.io/home-manager/index.html#ch-nix-flakes).

```sh
git clone https://github.com/lwndhrst/nixos-config ~/.config/home-manager
```
```sh
nix run home-manager/master -- switch --flake .#<host>
```

### Update as follows:

```sh
nix flake update && home-manager switch --flake .#<host>
```

### Get OpenGL and Vulkan to work on non-NixOS Systems with [nixGL](https://github.com/guibou/nixGL)

Invoke OpenGL/Vulkan programs by prefixing the appropriate wrapper:

- `nixGLIntel <program> <args>`
- `nixGLMesa <program> <args>`
- `nixGLNvidia <program> <args>`
- `nixVulkanIntel <program> <args>`
- `nixVulkanMesa <program> <args>`
- `nixVulkanNvidia <program> <args>`

```nix
# devShell config for nix develop
{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    nixgl = {
      url = "github:guibou/nixGL";
    };
  };

  outputs = { self, nixpkgs, nixgl }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          nixgl.overlays.default
        ];
      };

    in {
      devShell.${system} = pkgs.mkShell {
        packages = with pkgs; [
          mesa-demos
          pkgs.nixgl.nixGLMesa
        ];

        LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [
          xorg.libX11
        ];
      };
    };
}
```

### Misc

- For removing Windows PATH and disabling execution of Windows binaries on WSL add the following to `/etc/wsl.conf`:
   ```
   [interop]
   enabled = false
   appendWindowsPath = false
   ```
   Note: requires restart of WSL: `wsl --shutdown`.

- Set `zsh` as default shell by first adding its absolute path to `/etc/shells` and then running `chsh`
   ```
   /home/<user>/.nix-profile/bin/zsh
   ```
   ```sh
   chsh -s /home/<user>/.nix-profile/bin/zsh
   ```


## Usage as NixOS Module

Available modules:
- desktop
- laptop
- vbox

```nix
inputs.nixos-config = {
  url = "github:lwndhrst/nixos-config";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

```nix
# ...

lib.nixosSystem {
  inherit lib pkgs system;

  specialArgs = {
    inherit user;
  };

  modules = [
    ./configuration.nix

    # Home config from nixos-config flake
    nixos-config.nixosModules.desktop;
  ];
};

# ...
```








## Example flake for `nix develop`

Put flake into `path/to/project/flake.nix` and enter dev shell via `nix develop`.

```nix
{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

    in {
      devShell.${system} = pkgs.mkShell {
        buildInputs = with pkgs; [
          texlive.combined.scheme-full
          texlab
        ];
      };
    };
}
```
