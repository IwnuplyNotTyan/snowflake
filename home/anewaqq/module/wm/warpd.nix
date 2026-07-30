{ warpdLinuxPkg, ... }:

{
  home.packages = [ warpdLinuxPkg ];

  home.file.".config/warpd/config".text = ''
    normal_system_cursor: 1
  '';
}
