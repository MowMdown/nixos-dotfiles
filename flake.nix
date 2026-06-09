{
  description = "NixOS Systems";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixvim.url = "github:nix-community/nixvim/nixos-26.05";
    cachyos.url = "github:xddxdd/nix-cachyos-kernel";
    my-nixpkgs.url = "git+https://git.plexraid.stream/mowmdown/nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };
  outputs = inputs@{ self, nixpkgs, home-manager, plasma-manager, nixvim, cachyos, my-nixpkgs, ... }:
    let
      system = "x86_64-linux";
      mkHost = hostModule: nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          hostModule
          self.myModules.gpu-screen-recorder-ui
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
              plasma-manager.homeModules.plasma-manager
              nixvim.homeModules.nixvim
            ];
          }
        ];
      };
    in {
      myModules.gpu-screen-recorder-ui = import ./modules/gpu-screen-recorder-ui.nix;
      nixosConfigurations = {
        desktop = mkHost ./hosts/desktop/configuration.nix;
        laptop = mkHost ./hosts/laptop/configuration.nix;
        virtual = mkHost ./hosts/virtual/configuration.nix;
      };
    };
}
