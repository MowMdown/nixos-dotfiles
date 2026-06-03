{ config, lib, pkgs, modulesPath, ... }:

let
  nvme0n1p1 = "/dev/disk/by-uuid/217E-C306";
  nvme0n1p2 = "/dev/disk/by-uuid/1dd2e967-e85d-43cd-a61b-e48ffa8ff450";
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "uas" "usbhid" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom="US"
  '';

  fileSystems = {
    "/" = {
      device = nvme0n1p2;
      fsType = "btrfs";
      options = [ "subvol=@nixos" "compress=zstd" "noatime" "discard=async" "space_cache=v2" ];
    };

    "/home" = {
      device = nvme0n1p2;
      fsType = "btrfs";
      options = [ "subvol=@home" "compress=zstd" "noatime" "discard=async" "space_cache=v2" ];
    };

    "/swap" = {
      device = nvme0n1p2;
      fsType = "btrfs";
      options = [ "subvol=@swap" "nodatacow" "noatime" ];
    };

    "/boot" = {
      device = nvme0n1p1;
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
  };

  swapDevices = [{
    device = "/swap/swapfile";
    size = 16384;
  }];

  hardware = {
    firmware = [ pkgs.wireless-regdb ];
    graphics.enable = true;
    nvidia = {
      open = true;
      prime.offload.enable = true;
      prime.nvidiaBusId = "PCI:1@0:0:0";
      prime.amdgpuBusId = "PCI:5@0:0:0";
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}