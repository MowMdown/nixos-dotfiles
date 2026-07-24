{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./disko.nix
    ../../modules/common.nix
  ];

  boot = {
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "uas" "usbhid" "sd_mod" "sdhci_pci" ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-amd" "ntsync" ];
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v3;
    kernelParams = [
      "resume=LABEL=SWAP"
      "zswap.enabled=1"
      "zswap.compressor=zstd"
      "zswap.max_pool_percent=50"
    ];
    kernel.sysctl = { "vm.swappiness" = 100; };
    extraModulePackages = [ ];
    extraModprobeConfig = ''
      options cfg80211 ieee80211_regdom="US"
    '';
  };

  nix.settings = {
    substituters = [ "https://attic.xuyh0120.win/lantian" ];
    trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
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

  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
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
    bluetooth.powerOnBoot = true;
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
