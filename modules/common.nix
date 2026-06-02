{ config, pkgs, lib, ... }:

{
  boot.loader = {
    limine = {
      enable = true;
      label = "NixOS Linux";
      maxGenerations = 5;
    };

    efi.canTouchEfiVariables = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelParams = [
    "zswap.enabled=1"
    "zswap.compressor=zstd"
    "zswap.max_pool_percent=50"
  ];

  networking = {
    networkmanager.enable = true;
    nftables.enable = true;
    firewall.enable = true;
  };

  time.timeZone = "America/New_York";

  environment.etc."1password/custom_allowed_browsers" = {
    text = ''
      firefox
    '';
    mode = "0755";
  };

  hardware.openrazer.enable = true;
  
  services = {
    desktopManager.plasma6.enable = true;
    displayManager.plasma-login-manager.enable = true;

    avahi = {
      enable = true;
      nssmdns4 = true;
    };

    flatpak.enable = true;
    fstrim.enable = true;
    lact.enable = true;
    libinput.enable = true;
    printing.enable = true;

    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    power-profiles-daemon.enable = true;
    openssh.enable = true;

    tailscale.enable = true;
  };

  users.users.ryan = {
    isNormalUser = true;

    extraGroups = [
      "wheel"
      "audio"
      "video"
      "plugdev"
      "storage"
      "openrazer"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    _1password-gui
    alsa-utils
    ethtool
    lact
    openlinkhub
    openrazer-daemon
    steam-run
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "ryan" ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "26.05";
}
