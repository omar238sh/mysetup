{
  description = "My NixOS Unstable Flake Configuration";

  inputs = {
    
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: 
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
    nixosConfigurations = {
           
      omar = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit system; };
        modules = [
          ./configuration.nix
          
         
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";     
            home-manager.users.omar = import ./home.nix;
          }
        ];
      };
    };
  };
}

