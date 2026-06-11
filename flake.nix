{
  description = "NixOS Systems";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixvim.url = "github:nix-community/nixvim/nixos-26.05";
    cachyos.url = "github:xddxdd/nix-cachyos-kernel";
    my-nixpkgs = {
      url = "git+https://git.plexraid.stream/mowmdown/nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ self, nixpkgs, home-manager, nixvim, cachyos, my-nixpkgs, ... }:
    let
      system = "x86_64-linux";
      mkHost = hostModule: nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          hostModule
          my-nixpkgs.nixosModules.my-nixpkgs
          home-manager.nixosModules.home-manager
          {
            nixpkgs.overlays = [
              cachyos.overlays.default
              my-nixpkgs.overlays.default
            ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ryan = import ./home.nix;
            home-manager.backupFileExtension = "backup";
            home-manager.sharedModules = [
              nixvim.homeModules.nixvim
            ];
            disabledModules = [ "programs/gpu-screen-recorder.nix" ];
          }
        ];
      };
    in {
      nixosConfigurations = {
        desktop = mkHost ./hosts/desktop/configuration.nix;
        laptop = mkHost ./hosts/laptop/configuration.nix;
        virtual = mkHost ./hosts/virtual/configuration.nix;
      };
    };
}
