{
  system.autoUpgrade = {
    enable = true;
    flake = "~/nixos-dotfiles#$HOSTNAME";
    flags =[
      "--update-input" "nixpkgs"
      "--update-input" "home-manager"
    ];
    dates = "04:00";
    randomizedDelaySec = "15m";
    allowReboot = true;
    rebootWindow ={
      lower = "03:00";
      upper = "05:00";
    };
  };
}
