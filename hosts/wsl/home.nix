{ pkgs
, user
, ... 
}:

let 
  modules = import ../../modules;

in {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = with modules; [
    fzf
    tmux
    zathura
    zsh
  ];

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    packages = with pkgs; [
      fd
      gcc
      gh
      git
      htop
      libqalculate
      nil
      nitch
      openssh
      ranger
      ripgrep
      rustup
      stylua
      tree-sitter
      unzip
      wget

      # LLaMA
      # llama-cpp
    ];

    sessionVariables = { };

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "23.05";
  };
}
