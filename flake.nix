{
  description = "build with <3";

  inputs = {
	# Repository's
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
	# Addition stuff
    nixgl.url = "github:nix-community/nixGL";
	# Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = { nixgl, chaotic, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
      inherit system;
	  overlays = [ nixgl.overlay ];
      };
    in {
      homeConfigurations.anewaqq = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
	./home.nix 
	./host/anewaqq
	chaotic.nixosModules.default
	];
      };
      
      nixosConfigurations.anewaqq = nixpkgs.lib.nixosSystem {
	inherit system;
	modules = [
	  chaotic.nixosModules.default
	  home-manager.nixosModules.home-manager {
	    home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = true;
	    home-manager.users.youruser = import ./home.nix;
	  }
	];
      };
      
      nixosConfigurations.eweless3 = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./host/eweless3/configuration.nix
	  chaotic.nixosModules.default
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.youruser = import ./home.nix;
          }
        ];
      };
    };
}

