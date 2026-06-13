{ config, pkgs, lib, ... }:
{
  imports = [
    ./nixvim.nix
  ];

  boot = {
    loader.limine.enable = true;
    loader.limine.maxGenerations = 3;
    loader.efi.canTouchEfiVariables = true;
    kernel.sysctl = { "vm.swappiness" = 100; };
    kernelParams = [
      "zswap.enabled=1"
      "zswap.compressor=zstd"
      "zswap.max_pool_percent=50"
    ];
  };

  time.timeZone = "America/New_York";

  users.users.ryan = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "audio"
      "video"
      "plugdev"
      "storage"
      "networkmanager"
      "openrazer"
    ];
  };

  environment.etc = { 
    "1password/custom_allowed_browsers".text = "firefox";
    "1password/custom_allowed_browsers".mode = "0755";
  };

  environment.shellAliases = {
    ff = "clear && fastfetch";
    nix-switch = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#$HOSTNAME";
    nix-test   = "sudo nixos-rebuild test --flake ~/nixos-dotfiles#$HOSTNAME";
    nix-up     = "nix flake update --flake /home/ryan/nixos-dotfiles";
    nix-clean  = "nix-collect-garbage -d";
  };

  environment.systemPackages = with pkgs; [
    aha
    alsa-utils
    delve
    discord
    ethtool
    fastfetch
    firefox
    ghostscript
    go
    go
    gopls
    gopls
    kdePackages.filelight
    kdePackages.kcalc
    lact
    mpv
    nextcloud-client
    onlyoffice-desktopeditors
    openlinkhub
    openrazer-daemon
    protonplus
    python3
    steam-run
    thunderbird
    tree
    vim
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with vscode-extensions; [
        golang.go
        vscodevim.vim
      ];
    })
    waypipe
    wget
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
    power-profiles-daemon.enable = true;
    printing.enable = true;
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  security.rtkit.enable = true;

  programs = {
    gpu-screen-recorder-ui.enable = true;
    git.enable = true;
    bash.interactiveShellInit = builtins.readFile ../config/xdg-trash-cli;
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
