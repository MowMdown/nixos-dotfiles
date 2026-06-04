{
  imports = [
    ./hardware-configuration.nix
    ./tailscale.nix
    ../../modules/common.nix
    ../../modules/upgrade.nix
    ../../modules/nvidia.nix
  ];

  boot.kernelParams = [
    "resume=UUID=1dd2e967-e85d-43cd-a61b-e48ffa8ff450"
    "resume_offset=29169775"
  ];

  networking = {
    hostName = "laptop";
    usePredictableInterfaceNames = false;
    useDHCP = false;
    networking.interfaces = {
      wlan0.ipv4.addresses = [{
        address = "10.0.0.101";
        prefixLength = 8;
      }];
    };
    defaultGateway = "10.0.0.1";
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    networkmanager.enable = true;
    nftables.enable = true;
    firewall.enable = true;
  };

  hardware.openrazer.enable = true;

  boot.loader.limine.extraEntries = ''
  
    /Gentoo Linux
    protocol: linux
    kernel_path: boot():/kernel-7.0.11-gentoo-dist
    module_path: boot():/amd-uc.img
    module_path: boot():/initramfs-7.0.11-gentoo-dist.img
    cmdline: root=LABEL=ROOT rootflags=subvol=@gentoo rw nowatchdog zswap.enabled=1
    comment: Linux Kernel 7.0.11
  '';
}
