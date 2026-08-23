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
  
  gtk3.extraConfig = {
    gtk-application-prefer-dark-theme = true;
  };
};

home.sessionVariables = {
  GTK_THEME = "whitesur-GTK-Theme";
};
}
