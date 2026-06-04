{ config, lib, pkgs, modulesPath, ... }:

let
  nvme0n1p1 = "/dev/disk/by-uuid/DD83-436F";				            #Boot Partition
  nvme0n1p2 = "/dev/disk/by-uuid/be9582c6-5562-4617-9500-a1d6a6d00ddd"; #Root Partition
  nvme1n1p1 = "/dev/disk/by-uuid/bcf7f4cf-647f-46af-835a-7ae162a1972b"; #Swap Partition
  sdb1      = "/dev/disk/by-uuid/7599fa7b-6de7-4d2c-9423-6469e1b9d643"; #Data Disk
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "uas" "usbhid" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems = {
    "/" = {
      device = nvme0n1p2;
      fsType = "btrfs";
      options = [ "subvol=/@nixos" "compress=zstd:3" "noatime" "discard=async" "space_cache=v2" ];
    };
    "/nix" = {
      device = nvme0n1p2;
      fsType = "btrfs";
      options = [ "subvol=/@nix-store" "compress=zstd:3" "noatime" "discard=async" "space_cache=v2" ];
    };
    "/boot" = {
      device = nvme0n1p1;
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" "codepage=437" "iocharset=ascii" "shortname=mixed" "utf8" "errors=remount-ro" ];
    };
    "/home" = {
      device = nvme0n1p2;
      fsType = "btrfs";
      options = [ "subvol=/@home" "compress=zstd:3" "noatime" "discard=async" "space_cache=v2" ];
    };
    "/home/ryan/.local/share/Steam" = {
      device = nvme0n1p2;
      fsType = "btrfs";
      options = [ "subvol=/@steam" "compress=zstd:3" "noatime" "discard=async" "space_cache=v2" ];
    };
    "/var/tmp" = {
      device = nvme0n1p2;
      fsType = "btrfs";
      options = [ "subvol=/@tmp" "compress=zstd:3" "noatime" "discard=async" "space_cache=v2" ];
    };
    "/var/log" = {
      device = nvme0n1p2;
      fsType = "btrfs";
      options = [ "subvol=/@log" "compress=zstd:3" "noatime" "discard=async" "space_cache=v2" ];
    };
    "/mnt/disk2" = {
      device = sdb1;
      fsType = "btrfs";
      options = [ "compress=zstd:3" "noatime" "discard=async" "space_cache=v2" ];
    };
  };

  swapDevices = [{
    device = nvme1n1p1;
  }];

  hardware.firmware = [ pkgs.wireless-regdb ];
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}