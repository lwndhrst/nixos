{ pkgs, ... }:

let
  gtkThemes = {
    dracula = {
      package = pkgs.dracula-theme;
      name = "Dracula";
    };

    graphite = {
      package = pkgs.graphite-gtk-theme;
      name = "Graphite-Dark";
    };

    orchis = {
      package = pkgs.orchis-theme;
      name = "Orchis-Dark";
    };
  };

  iconThemes = {
    papirus = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
  };

  # set theme here
  theme = gtkThemes.graphite;
  iconTheme = iconThemes.papirus;

in {
  gtk = {
    inherit theme iconTheme;
    enable = true;
  };

  home.file.".config/gtk-4.0" = {
    recursive = true;
    source = "${theme.package}/share/themes/${theme.name}/gtk-4.0";
  };
}
