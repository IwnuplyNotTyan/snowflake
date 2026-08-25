{ pkgs, ... }:

{
gtk = {
  enable = true;
  
  iconTheme = {
    name = "whitesur";
    package = pkgs.whitesur-icon-theme;
  };
  
  font = {
    name = "Iosevka Nerd Font";
    size = 11;
  };

  theme = {
    name = "Adwaita-dark";
    package = pkgs.gnome-themes-extra;
  };
  
  gtk3.extraConfig = {
    gtk-application-prefer-dark-theme = true;
  };

  gtk4 = {
  theme = null;
  extraConfig = {
      gtk-application-prefer-dark-theme = true;
  };
  };
};

dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

xdg.portal = {
  enable = true;
  extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  config.common.default = "*";
};

home.sessionVariables = {
  GTK_THEME = "whitesur-GTK-Theme";
};
}
