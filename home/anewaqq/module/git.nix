{ pkgs, pkgsUnstable, lib, isDarwin, ... }:

let
  driftNix = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/nix-community/nur-combined/d3178443af01fc749375b71ed816154d447763c9/repos/aymanbagabas/pkgs/drift/default.nix";
    sha256 = "sha256:0lmfm7yc7jxxm1z3n7amy6zwlsj10s1hfs26prgcnvzykxmc0b42";
  };
  drift = pkgs.callPackage driftNix {};
in

{
  home.packages = with pkgs; [
    git-lfs
    lazygit
    github-cli
    drift
    git

    #nix4gitbutler.packages.x86_64-linux.cli
  ];

  xdg.dataFile."gh/extensions" = {
    source = pkgs.linkFarm "gh-extensions" [
      { name = "gh-dash"; path = "${pkgsUnstable.gh-dash}/bin"; }
      { name = "gh-eco"; path = "${pkgsUnstable.gh-eco}/bin"; }
    ];
  };

programs.git = {
  enable = true;

  signing.format = null;
  
  settings = {
    user = {
      name = "IwnuplyNotTyan";
      email = "ikissiwnuply@gmail.com";
    };

    pull.rebase = true;
    init.defaultBranch = "main";
    
    http = {
      lowSpeedLimit = 1000;
      lowSpeedTime = 60;
      postBuffer = 524288000;
    };
    
    filter.lfs = {
      required = true;
      clean = "git-lfs clean -- %f";
      smudge = "git-lfs smudge -- %f";
      process = "git-lfs filter-process";
    };
    
    pager.diff = "drift";
  } // lib.optionalAttrs (!isDarwin) {
    credential."https://github.com" = {
      helper = "/home/q/.nix-profile/bin/gh auth git-credential";
    };
    credential."https://gist.github.com" = {
      helper = "/home/q/.nix-profile/bin/gh auth git-credential";
    };
  } // lib.optionalAttrs isDarwin {
    credential."https://github.com" = {
      helper = "/Users/q/.nix-profile/bin/gh auth git-credential";
    };
    credential."https://gist.github.com" = {
      helper = "/Users/q/.nix-profile/bin/gh auth git-credential";
    };
  };
};
}
