{
  description = "NixOS Systems";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixvim.url = "github:nix-community/nixvim/nixos-26.05";
    cachyos.url = "github:xddxdd/nix-cachyos-kernel/release";
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    my-nixpkgs = {
      url = "git+https://git.plexraid.stream/mowmdown/nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ self, cachyos, disko, my-nixpkgs, nixpkgs, nixvim,  ... }:
    let
      system = "x86_64-linux";
      mkHost = hostModule: nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          hostModule
          disko.nixosModules.disko
          my-nixpkgs.nixosModules.my-nixpkgs
          nixvim.nixosModules.nixvim
          {
            nixpkgs.overlays = [
              cachyos.overlays.pinned
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
