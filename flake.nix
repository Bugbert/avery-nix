{
  description = "System Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    gitwatch.url = "github:gitwatch/gitwatch";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, gitwatch, ... }: {
    nixosConfigurations = {
      avery-nix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
	modules = [
	  ./configuration.nix
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
