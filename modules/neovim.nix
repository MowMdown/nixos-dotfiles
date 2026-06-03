{ config, pkgs, lib, ...}

{
  home.packages = with pkgs; [
    ripgrep
    fd
    fzf
    lua-language-server
    nixpkgs-fmt
    nodejs
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    # optional: To manage your plugins with nix, instead of with lazy.nvim,
    # plugins = with pkgs.vimPlugins; [
    #     telescope-nvim
    #     nvim-treesitter
    #     nvim-lspconfig
    # ];
  };
}
