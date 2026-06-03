{ config, pkgs, lib, ... }:

let
  secrets = import ./secrets.nix;
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
      nvim = "nvim";
    };
in

{
  imports = [
    ./modules/neovim.nix
  ];

  home = {
    username = "ryan";
    homeDirectory = "/home/ryan";
    stateVersion = "26.05";
  };

  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;

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
    initExtra = builtins.readFile ./config/xdg-trash-cli;
    shellAliases = {
      ff = "clear && fastfetch";
      nix-switch = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#$HOSTNAME";
      nix-test = "sudo nixos-rebuild test --flake ~/nixos-dotfiles#$HOSTNAME";
    };
  };
}
