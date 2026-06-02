{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "uas" "usbhid" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom="US"
  '';

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/1dd2e967-e85d-43cd-a61b-e48ffa8ff450";
      fsType = "btrfs";
      options = [ "subvol=@nixos" "compress=zstd" "noatime" "discard=async" "space_cache=v2" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/217E-C306";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/1dd2e967-e85d-43cd-a61b-e48ffa8ff450";
      fsType = "btrfs";
      options = [ "subvol=@home" "compress=zstd" "noatime" "discard=async" "space_cache=v2" ];
    };

  fileSystems."/swap" =
    { device = "/dev/disk/by-uuid/1dd2e967-e85d-43cd-a61b-e48ffa8ff450";
      fsType = "btrfs";
      options = [ "subvol=@swap" "nodatacow" "noatime" ];
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
      prime = {
        offload.enable = true;
        nvidiaBusId = "PCI:1@0:0:0";
        amdgpuBusId = "PCI:5@0:0:0";
      };
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}