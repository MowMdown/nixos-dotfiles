{
  imports = [
    ./hardware-configuration.nix
    ./tailscale.nix
    ../../modules/common.nix
    ../../modules/upgrade.nix
    ../../modules/nvidia.nix
  ];

  networking.hostName = "laptop";

  boot.loader.limine.extraEntries = ''
    /Gentoo Linux
    protocol: linux
    kernel_path: boot():/kernel-7.0.10-p1-gentoo-dist
    module_path: boot():/amd-uc.img
    module_path: boot():/initramfs-7.0.10-p1-gentoo-dist.img
    cmdline: root=LABEL=ROOT rootflags=subvol=@gentoo rw nowatchdog zswap.enabled=0
    comment: Linux Kernel 7.0.10-p1
  '';
}
