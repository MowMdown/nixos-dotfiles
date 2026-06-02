{
  imports = [
    ./hardware-configuration.nix
    ./tailscale.nix
    ../../modules/common.nix
    ../../modules/vm.nix
  ];

  networking.hostName = "virtual";
}
