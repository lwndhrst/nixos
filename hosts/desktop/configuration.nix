{ config
, lib
, pkgs
, nur
, user
, ... 
}:

let
  packages = import ../../packages { inherit pkgs; };

in {
  imports = [ 
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos"; # Define your hostname.

  services = {
    xserver = {
      videoDrivers = [ "amdgpu" ];
      displayManager.setupCommands = ''
        ${pkgs.xorg.xrandr}/bin/xrandr -s 1920x1080 -r 240
      '';
    };

    # Printer stuff
    printing.enable = true;

    # Needed for wireless printer/scanner
    avahi = { 
      enable = true;
      nssmdns = true;
      publish = {
        enable = true;
        addresses = true;
        userServices = true;
      };
    };

    # Sound
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };
  };

  programs = {
    steam.enable = true;
  };
}
