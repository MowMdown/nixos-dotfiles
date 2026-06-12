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
  };
  outputs = inputs@{ self, nixpkgs, nixvim, cachyos, my-nixpkgs, ... }:
    let
      system = "x86_64-linux";
      mkHost = hostModule: nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          hostModule
          my-nixpkgs.nixosModules.my-nixpkgs
          nixvim.nixosModules.nixvim
          {
            nixpkgs.overlays = [
              cachyos.overlays.default
              my-nixpkgs.overlays.default
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