# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config
, lib
, pkgs
, nur
, user
, ... 
}:

let
  derivations = import ../../derivations { inherit pkgs; };

in {
  imports = [ 
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot = {
    # Use the latest available Kernel packages.
    kernelPackages = pkgs.linuxPackages_latest;

    # Use the systemd-boot EFI boot loader.
    loader = {
      systemd-boot = { 
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  networking.hostName = "nixos-vbox"; # Define your hostname.

  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager = { # Easiest to use and most distros use this by default.
    enable = true;
    wifi.powersave = false;
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services = {
    xserver = {
      enable = true;

      layout = "us";
      xkbOptions = "caps:escape";

      displayManager = {
        sddm = {
          enable = true;
          theme = "rose-pine";
          settings = {
            Theme.CursorTheme = "Bibata-Modern-Ice";
          };
        };

        # session = [{
        #   manage = "window";
        #   name = "awesome";
        #   start = ''
        #     ${pkgs.awesome}/bin/awesome
        #   '';
        # }];

        defaultSession = "none+awesome";

        # setupCommands = ''
        #   ${pkgs.xorg.xrandr}/bin/xrandr -s 1920x1080 -r 240
        # '';
      };

      windowManager.awesome.enable = true;

      # Enable touchpad support (enabled default in most desktopManager).
      # libinput.enable = true;
    };

    # Printer stuff
    # printing.enable = true;

    # Needed for wireless printer/scanner
    # avahi = { 
    #   enable = true;
    #   nssmdns = true;
    #   publish = {
    #     enable = true;
    #     addresses = true;
    #     userServices = true;
    #   };
    # };

    # Sound
    # pipewire = {
    #   enable = true;
    #   alsa = {
    #     enable = true;
    #     support32Bit = true;
    #   };
    #   pulse.enable = true;
    #   jack.enable = true;
    # };

    # Needed for Gnome Files/Nautilus
    # gvfs.enable = true;
  };

  fonts = {
    fonts = with pkgs; [
      # CJK fonts
      source-han-sans
      source-han-serif

      # Icons, emoji, etc.
      font-awesome

      # Nerdfont overrides
      (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
    ];
  };

  # Set system-wide variables and packages.
  environment = {
    shells = with pkgs; [ zsh ];
    pathsToLink = [
      "/share/zsh"
    ];

    variables = {
      EDITOR = "nvim";
    };

    systemPackages = with pkgs; [
      gcc
      vim
      wget
      git

      # NUR packages
      # config.nur.repos.shadowrz.sddm-sugar-candy

      # Cursor Theme
      bibata-cursors

      # Custom packages
      derivations.sddm-rose-pine-theme
    ];
  };

  # programs = {
  #   steam.enable = true;
  # };

  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2d";
    };

    # Enable flakes.
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
