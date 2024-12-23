{ inputs, pkgs-unstable, ... }:
let
  improvedft = pkgs-unstable.vimUtils.buildVimPlugin {
    name = "improvedft";
    src = pkgs-unstable.fetchFromGitHub {
      owner = "chrisbra";
      repo = "improvedft";
      rev = "1f0b78b55ba5fca70db0f584d8b5e56a35fd26f6";
      hash = "sha256-Db1NkRdNNjZoKHpKErNFYI8BBfdX2wCmfohV2uAwVtA=";
    };
  };
in
{
  imports = [
    ./colorscheme.nix
    ./completion-menu.nix
    ./file-explorer.nix
    ./file-switcher.nix
    ./formatter.nix
    ./fuzzy-finder.nix
    ./language-server.nix
    ./search-highlighter.nix
    ./source-control.nix
    ./statusline.nix
    ./syntax-parser.nix
    ./terminal-manager.nix
  ];

  home-manager.users.christian = {
    imports = [
      inputs.nixvim.homeManagerModules.nixvim
    ];

    programs.nixvim = {
      enable = true;
      package = pkgs-unstable.neovim-unwrapped;

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

      keymaps = [
        {
          key = "<C-i>";
          action = "<C-I>";
          mode = "n";
          options.silent = true;
        }
        {
          key = "gnd";
          action.__raw = ''
            function()
              vim.diagnostic.goto_next()
            end
          '';
          mode = "n";
          options.silent = true;
        }
        {
          key = "gpd";
          action.__raw = ''
            function()
              vim.diagnostic.goto_prev()
            end
          '';
          mode = "n";
          options.silent = true;
        }
      ];

      extraPlugins = [ improvedft ];

      plugins = {
        auto-save = {
          enable = true;
          settings = {
            trigger_events.__raw = ''
              {
                immediate_save = { "BufLeave", "FocusLost" },
                defer_save = { },
                cancel_deferred_save = { },
              }
            '';
            write_all_buffers = true;
          };
        };
        autoclose.enable = true;
        vim-surround.enable = true;
      };
    };
  };
}
