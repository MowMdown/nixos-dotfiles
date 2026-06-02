{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
    ../../modules/vm.nix
  ];

  networking.hostName = "virtual";
}