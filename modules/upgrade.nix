{
  environment.etc."gitconfig".text = ''
  [safe]
      directory = /home/ryan/nixos-dotfiles
  '';

  system.autoUpgrade = {
    enable = true;
    flake = "/home/ryan/nixos-dotfiles#$HOSTNAME";
    flags = [
      "--print-build-logs"
    ];
    dates = "04:00";
    randomizedDelaySec = "15min";
    allowReboot = true;
    rebootWindow = {
      lower = "03:00";
      upper = "05:00";
    };
  };
}
