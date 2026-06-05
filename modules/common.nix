{ config, pkgs, lib, ... }:
{
  boot.loader.limine ={
    enable = true;
    maxGenerations = 5;
    resolution = "1920x1080x32";
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernel.sysctl = { "vm.swappiness" = 100; };
  boot.kernelParams = [
    "zswap.enabled=1"
    "zswap.compressor=zstd"
    "zswap.max_pool_percent=50"
  ];

  time.timeZone = "America/New_York";
  
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
    tailscale.enable = true;
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  
  users.users.ryan = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "video" "plugdev" "storage" "openrazer" ];
  };

  environment.etc."1password/custom_allowed_browsers".text = ''
    firefox
  '';
  environment.etc."1password/custom_allowed_browsers".mode = "0755";
  environment.systemPackages = with pkgs; [
    _1password-gui
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

  programs = {
    _1password-gui.enable = true;
    _1password-gui.polkitPolicyOwners = [ "ryan" ];
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
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.warn-dirty = false;

  system.stateVersion = "26.05";
}
