{ config, pkgs, ... }:

let
  secrets = import ./secrets.nix;
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  #  configs = {
  #      nvim = "nvim";
  #    };
in

{
  imports = [
    ./modules/nixvim.nix
  ];

  home = {
    username = "ryan";
    homeDirectory = "/home/ryan";
    stateVersion = "26.05";
  };

  #  xdg.configFile = builtins.mapAttrs (name: subpath: {
  #    source = create_symlink "${dotfiles}/${subpath}";
  #    recursive = true;
  #  }) configs;

  home.packages = with pkgs; [
    delve
    discord
    fastfetch
    firefox
    go
    gopls
    kdePackages.kcalc
    kdePackages.filelight
    nextcloud-client
    onlyoffice-desktopeditors
    protonplus
    thunderbird
    tree
    vim
    wget
  ];

  programs.vscodium = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      golang.go
      vscodevim.vim
    ];
  };
  programs.git = {
    enable = true;
    settings.user = {
      name = secrets.gitUser;
      email = secrets.gitEmail;
    };
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
