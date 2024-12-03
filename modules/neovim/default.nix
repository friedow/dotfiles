{ inputs, pkgs-unstable, ... }:
let
  custom-plugins = import ./custom-plugins.nix pkgs-unstable;
in
{

  imports = [
    ./colorscheme.nix
    ./completion-menu.nix
    ./file-explorer.nix
    ./file-switcher.nix
    ./fuzzy-finder.nix
    ./language-server.nix
    ./search-highlighter.nix
    ./source-control.nix
    ./syntax-parser.nix
    ./terminal-manager.nix
  ];
  home-manager.users.christian = {
    imports = [
      inputs.nixvim.homeManagerModules.nixvim
    ];

    home.packages = with pkgs-unstable; [
      # formatter dependencies
      prettierd
      black
      nixfmt-rfc-style
      stylua
    ];

    programs.nixvim = {
      enable = true;

      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      globals = {
        mapleader = " ";
      };

      opts = {
        clipboard = "unnamedplus";
        fillchars = "eob: ";
        mouse = null;
        number = true;
        relativenumber = true;
        scrolloff = 8;
        cmdheight = 0;
        cursorline = true;
        laststatus = 0;
        tabstop = 2;
        shiftwidth = 0;
        expandtab = true;
      };

      extraConfigLua = (builtins.readFile ./init.lua);

      extraPlugins = with pkgs-unstable.vimPlugins; [
        vim-surround
        autoclose-nvim
        custom-plugins.improvedft
        custom-plugins.format-on-save-nvim
        custom-plugins.incline-nvim
        actions-preview-nvim
        vim-startuptime
      ];
    };
  };
}
