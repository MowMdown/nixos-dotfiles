{ config, pkgs, lib, ... }:

{
  boot = {
    loader.limine.enable = true;
    loader.limine.maxGenerations = 3;
    loader.efi.canTouchEfiVariables = true;
    kernel.sysctl = { "vm.swappiness" = 100; };
    #kernelPackages = pkgs.linuxPackages_latest;
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
    kernelParams = [
      "zswap.enabled=1"
      "zswap.compressor=zstd"
      "zswap.max_pool_percent=50"
    ];
  };

  time.timeZone = "America/New_York";

  users.users.ryan = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "video" "plugdev" "storage" "networkmanager" "openrazer" ];
  };
  
  environment.etc."1password/custom_allowed_browsers".text = "firefox";
  environment.etc."1password/custom_allowed_browsers".mode = "0755";
  environment.systemPackages = with pkgs; [
    aha
    alsa-utils
    ethtool
    ghostscript
    lact
    openlinkhub
    openrazer-daemon
    python3
    steam-run
    waypipe
    wineWow64Packages.staging
    winetricks
  ];

  services = {
    desktopManager.plasma6.enable = true;
    displayManager.plasma-login-manager.enable = true;
    flatpak.enable = true;
    fstrim.enable = true;
    lact.enable = true;
    libinput.enable = true;
    openssh.enable = true;
    pipewire.enable = true;
    pipewire.pulse.enable = true;
    power-profiles-daemon.enable = true;
    printing.enable = true;
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "ryan" ];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    protontricks.enable = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.warn-dirty = false;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  system.stateVersion = "26.05";
}
