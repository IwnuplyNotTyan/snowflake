{ pkgs, isDarwin, lib, ... }:
{
  nixpkgs = {
    config = {
      allowUnsupportedSystem = true;
      allowBroken = true;
      allowUnfree = true;
    };
  };
  nix = { 
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    registry = lib.mkIf isDarwin {
      nixpkgs = {
        from = {
          type = "indirect";
          id = "nixpkgs";
        };
        to = {
          type = "github";
          owner = "NixOS";
          repo = "nixpkgs";
          ref = "nixos-25.11";
        };
      };
    };
  };
}
