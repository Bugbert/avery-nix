{
  description = "System Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    gitwatch.url = "github:gitwatch/gitwatch";
  };

  outputs = inputs@{ self, nixpkgs, lix-module, home-manager, gitwatch, ... }: {
    nixosConfigurations = {
      avery-nix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
	modules = [
	  ./configuration.nix
	  lix-module.nixosModules.default
	  home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.avery = import ./avery/home.nix;
	  }
	] ++ gitwatch.modules;
      };
    };
  };
}
