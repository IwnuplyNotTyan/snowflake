{ lib, isDarwin, ... }:

{
 imports = [
  ./kitty.nix   # Terminal
  ] ++ lib.optionals (!isDarwin) [
  ./i3.nix 	# WM
  ({ pkgs, lib, ... }: {
    _module.args.isSway = false; # Disabled
  })
  #./sway.nix
  ./picom.nix	# Picom
  #./qs/qs.nix  # Widgets
  ./eww/eww.nix
  ./warpd.nix   # Warpd
  ]
  ++ lib.optionals (isDarwin) [
  #./neru.nix	# Neru
  #./miri.nix	# WM
  ./skhd.nix    # Hotkey's
 ];
}
