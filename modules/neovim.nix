{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
    ripgrep
    fd
    fzf
    lua-language-server
    nixpkgs-fmt
    nodejs
  ];

  programs.neovim = {
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      telescope-nvim
      nvim-treesitter
      nvim-lspconfig
    ];
  };
}
