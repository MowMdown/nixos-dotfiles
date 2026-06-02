{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/profiles/qemu-guest.nix")
    ];

  boot.initrd.availableKernelModules = [ "uhci_hcd" "ehci_pci" "ahci" "virtio_pci" "sr_mod" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-label/NIX";
      fsType = "btrfs";
      options = [ "noatime" "compress=zstd:3" "space_cache=v2" "discard=async" "subvol=@" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-label/NIX";
      fsType = "btrfs";
      options = [ "noatime" "compress=zstd:3" "space_cache=v2" "discard=async" "subvol=@home" ];
    };

  fileSystems."/var/tmp" =
    { device = "/dev/disk/by-label/NIX";
      fsType = "btrfs";
      options = [ "noatime" "compress=zstd:3" "space_cache=v2" "discard=async" "subvol=@tmp" ];
    };

  fileSystems."/var/log" =
    { device = "/dev/disk/by-label/NIX";
      fsType = "btrfs";
      options = [ "noatime" "compress=zstd:3" "space_cache=v2" "discard=async" "subvol=@log" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/EFI";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices = [{
    device = "/dev/disk/by-label/SWAP";
    options = [ "discard" ];
  }];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}