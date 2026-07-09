{
  description = "My NixOS Unstable Flake Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };    

    nixConfig = {
      extra-substituters = [
        "https://omar238sh.cachix.org"
        "https://cache.nixos.org"
        "https://ooo-nix.cachix.org"
        "https://noctalia.cachix.org"
      ];
      extra-trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "ooo-nix.cachix.org-1:gjBzZvTs8M5InohgPRGayu75FvjJFajalxWS5uUuk8Q="
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        "omar238sh.cachix.org-1:QOVqP8RL66i+X8zvEM4pBlOZaoRoNzUt1hFYSvCgopI="      
      ];
    };    
  };


  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      
      # pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        omar = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit system inputs; };
          modules = [
            ./configuration.nix
            ./noctalia.nix
            ./home-manager.nix
          ];
        };
      };
    };
}
