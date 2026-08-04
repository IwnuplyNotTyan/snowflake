{ pkgs, lib, warpdLinuxPkg, warpdMacosPkg, isDarwin ? false, ... }:

let
  keyboardSwitcher = pkgs.runCommand "keyboardSwitcher" {} ''
    mkdir -p $out/bin
    cp ${./keyboardSwitcher} $out/bin/keyboardSwitcher
    chmod +x $out/bin/keyboardSwitcher
  '';
in
{
  services.skhd = lib.mkIf isDarwin {
    enable = true;
    config = ''
      cmd + alt - x : ${keyboardSwitcher}/bin/keyboardSwitcher select "U.S." 2>/dev/null; ${warpdMacosPkg}/bin/warpd --hint
    '';
  };

  home.packages = lib.mkIf (!isDarwin) [ warpdLinuxPkg ];

  home.file.".config/warpd/config".text = ''
    normal_system_cursor: 1
  '';
}
