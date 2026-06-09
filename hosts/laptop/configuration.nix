{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./fstab.nix
    ../../modules/common.nix
    ../../modules/upgrade.nix
  ];

  boot = {
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "uas" "usbhid" "sd_mod" "sdhci_pci" ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
    kernelParams = [
      "resume=UUID=1dd2e967-e85d-43cd-a61b-e48ffa8ff450"
      "resume_offset=29169775"
    ];
    extraModulePackages = [ ];
    extraModprobeConfig = ''
      options cfg80211 ieee80211_regdom="US"
    '';
    loader.limine.extraEntries = ''
      /Gentoo Linux
      protocol: linux
      kernel_path: boot():/kernel-7.0.11-gentoo-dist
      module_path: boot():/amd-uc.img
      module_path: boot():/initramfs-7.0.11-gentoo-dist.img
      cmdline: root=LABEL=ROOT rootflags=subvol=@gentoo rw nowatchdog zswap.enabled=1
      comment: Linux Kernel 7.0.11
    '';
  };

  networking = {
    hostName = "laptop";
    usePredictableInterfaceNames = false;
    networkmanager.enable = true;
    networkmanager.wifi.backend = "iwd";
    nftables.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 53317 ]; # LocalSend
      allowedUDPPorts = [ 53317 config.services.tailscale.port ]; # LocalSend, Tailscale
      trustedInterfaces = [ "tailscale0" ];
    };
  };

  services = {
    tailscale.enable = true;
    networkd-dispatcher = {
      enable = true;
      rules."50-tailscale-optimizations" = {
        onState = [ "routable" ];
        script = "${pkgs.ethtool}/bin/ethtool -K wlan0 rx-udp-gro-forwarding on rx-gro-list off";
      };
    };
    xserver.enable = true;
    xserver.videoDrivers = [ "amdgpu" "nvidia" ];
  };

  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];

  hardware = {
    openrazer.enable = true;
    bluetooth.enable = true;
    bluetooth.powerOnBoot = false;
    firmware = with pkgs; [
      wireless-regdb
    ];
    graphics.enable = true;
    graphics.enable32Bit = true;
    nvidia = {
      open = true;
      prime.offload.enable = true;
      prime.nvidiaBusId = "PCI:1@0:0:0";
      prime.amdgpuBusId = "PCI:5@0:0:0";
    };
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
