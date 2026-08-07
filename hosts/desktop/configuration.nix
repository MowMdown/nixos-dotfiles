{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./disko.nix
    ./fstab.nix
    ../../modules/common.nix
  ];
  
  boot = {
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "uas" "usbhid" "sd_mod" "sdhci_pci" ];
    initrd.kernelModules = [ "amdgpu" ];
    kernelModules = [ "kvm-amd" "ntsync" ];
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v3;
    kernelParams = [
      "resume=LABEL=SWAP"
      "zswap.enabled=1"
      "zswap.compressor=zstd"
      "zswap.max_pool_percent=50"
    ];
    kernel.sysctl = { "vm.swappiness" = 100; };
    extraModprobeConfig = ''
      options cfg80211 ieee80211_regdom="US"
    '';
    extraModulePackages = [ ];
    loader.limine.extraEntries = ''
      /Gentoo Linux
        protocol: linux
        kernel_path: boot():/kernel-7.1.7-gentoo-dist-bin
        module_path: boot():/amd-uc.img
        module_path: boot():/initramfs-7.1.7-gentoo-dist-bin.img
        cmdline: root=LABEL=ARCH rootflags=subvol=@gentoo rw nowatchdog amdgpu.ppfeaturemask=0xffffffff zswap.enabled=1 zswap.compressor=lz4
        comment: Linux Kernel 7.1.7
      /Windows 11
        protocol: efi
        path: guid(4e4d4d22-81e9-4d8a-9b07-528d0bf1aa59):/EFI/Microsoft/Boot/bootmgfw.efi
        comment: Windows 11 Pro
    '';
  };
  
  nix.settings = {
    substituters = [ "https://attic.xuyh0120.win/lantian" ];
    trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
  };

  networking = {
    hostName = "desktop";
    usePredictableInterfaceNames = false;
    networkmanager.enable = true;
    networkmanager.wifi.backend = "iwd";
    nftables.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 53317 ];
      allowedUDPPorts = [ 53317 config.services.tailscale.port ];
      trustedInterfaces = [ "tailscale0" ];
    };
  };
  
  services = {
    tailscale.enable = true;
    networkd-dispatcher = {
      enable = true;
      rules."50-tailscale-optimizations" = {
        onState = [ "routable" ];
        script = "${pkgs.ethtool}/bin/ethtool -K eth0 rx-udp-gro-forwarding on rx-gro-list off";
      };
    };
    xserver.enable = true;
    xserver.videoDrivers = [ "amdgpu" ];
  };
  
  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];
  
  hardware = {
    amdgpu.overdrive.enable = true;
    openrazer.enable = true;
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
    firmware = with pkgs; [
      wireless-regdb
    ];
    graphics.enable = true;
    graphics.enable32Bit = true;
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
