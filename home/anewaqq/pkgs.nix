{
  pkgs,
  lib,
  minPkg,
  isDarwin ? false,
  ...
}:

{
  home.packages =
    with pkgs;
    [
      # Tools
      bottom
      comma

      # SHH
      openssh

      # Shell
      ripgrep
      bat
      eza

      # Etc
      nodejs_22
      minPkg
    ]
    ++ lib.optionals (!isDarwin) [
      nixgl.nixGLIntel
      bluetuith
      ripdrag
    ];

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "unrar"
    ];
}
