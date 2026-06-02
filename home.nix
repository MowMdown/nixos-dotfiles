
{ config, pkgs, ... }:

let
  secrets = import ./secrets.nix;
in
{
  home = {
    username = "ryan";
    homeDirectory = "/home/ryan";
    stateVersion = "26.05";
  };

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    discord
    fastfetch
    gpu-screen-recorder-gtk
    kdePackages.kcalc
    nextcloud-client
    onlyoffice-desktopeditors
    protonplus
    tree
    vim
    wget
  ];

  programs.git = {
    enable = true;
    settings.user = {
      name = secrets.gitUser;
      email = secrets.gitEmail;
    };
  };

  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
  };

  programs.bash = {
    enable = true;
    initExtra = builtins.readFile ./configs/xdg-trash-cli;

    shellAliases = {
      ff = "clear && fastfetch";
      nix-switch = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#$HOSTNAME";
      nix-test = "sudo nixos-rebuild test --flake ~/nixos-dotfiles#$HOSTNAME";
    };
  };
}
