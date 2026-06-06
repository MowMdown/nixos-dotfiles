{
  imports = [
    ./hardware-configuration.nix
    ./tailscale.nix
    ../../modules/common.nix
    ../../modules/upgrade.nix
  ];

  networking = {
    hostName = "desktop";
    usePredictableInterfaceNames = false;
    networkmanager.enable = true;
    networkmanager.wifi.backend = "iwd";
    nftables.enable = true;
  };
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 53317 ];
    allowedUDPPorts = [ 53317 ];
  };

  hardware.openrazer.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;

  boot.loader.limine.extraEntries = ''
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
}
