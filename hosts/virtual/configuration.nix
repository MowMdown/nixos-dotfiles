{
  imports = [
    ./hardware-configuration.nix
    ./tailscale.nix
    ../../modules/common.nix
    ../../modules/nixvim.nix
    ../../modules/upgrade.nix
    ../../modules/vm.nix
  ];

    networking = {
      hostName = "virtual";
      usePredictableInterfaceNames = false;
      networkmanager.enable = true;
      nftables.enable = true;
      firewall.enable = true;
  };

}
