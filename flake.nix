{
  description = "NixOS Systems";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    with nixpkgs.lib;
    let
      system = "x86_64-linux";
      homeModule = {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.ryan = import ./home.nix;
          backupFileExtension = "backup";
        };
      };
      mkHost = hostModule: nixosSystem {
        inherit system;
        modules = [ hostModule home-manager.nixosModules.home-manager homeModule ];
      };
    in
    {
      nixosConfigurations = {
        desktop = mkHost ./hosts/laptop/configuration.nix;
        laptop = mkHost ./hosts/laptop/configuration.nix;
        virtual = mkHost ./hosts/virtual/configuration.nix;
      };
    };
}