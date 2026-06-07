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
    initrd.kernelModules = [ "amdgpu" ];
    kernelModules = [ "kvm-amd" ];
    kernelParams = [
      "resume=UUID=bcf7f4cf-647f-46af-835a-7ae162a1972b"
    ];
    extraModprobeConfig = ''
      options cfg80211 ieee80211_regdom="US"
    '';
    extraModulePackages = [ ];
    loader.limine.extraEntries = ''
      /Windows 11
      protocol: efi
      path: guid(4e4d4d22-81e9-4d8a-9b07-528d0bf1aa59):/EFI/Microsoft/Boot/bootmgfw.efi
      comment: Windows 11 Pro

      /Gentoo Linux
      protocol: linux
      kernel_path: boot():/kernel-7.0.10-gentoo-r1-custom
      module_path: boot():/amd-uc.img
      module_path: boot():/initramfs-7.0.10-gentoo-r1-custom.img
      cmdline: root=LABEL=ARCH rootflags=subvol=@gentoo rw nowatchdog amdgpu.ppfeaturemask=0xffffffff zswap.enabled=1 zswap.compressor=lz4
      comment: Linux Kernel 7.0.10-r1
    '';
  };

  networking = {
    hostName = "desktop";
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
        script = "${pkgs.ethtool}/bin/ethtool -K eth0 rx-udp-gro-forwarding on rx-gro-list off";
      };
    };
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
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
