{
  imports = [
    ./hardware-configuration.nix
    ./tailscale.nix
    ../../modules/common.nix
    ../../modules/updates.nix
    ../../modules/vm.nix
  ];

  networking.hostName = "virtual";
}
