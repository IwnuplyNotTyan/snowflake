{ pkgs, ... }:

{
  home.username = "q";
  home.homeDirectory = "/home/q";

  home.packages = with pkgs; [
    # Tools
    git
    neovim

    # Programming languages
    go
    lua
    eslint

    # Package manager's
    yarn

    # Debuger
    deadnix

    # Package manager
    nix-output-monitor

    # Nixgl
    nixgl.nixGLIntel
  ];

  programs.bash.enable = true;

  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
