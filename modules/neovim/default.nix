{ inputs, pkgs-unstable, ... }:
let
  custom-plugins = import ./custom-plugins.nix pkgs-unstable;
in
{

  imports = [
    ./colorscheme.nix
    ./file-explorer.nix
    ./syntax-parser.nix
    ./terminal-manager.nix
  ];
  home-manager.users.christian = {
    imports = [
      inputs.nixvim.homeManagerModules.nixvim
    ];

    home.packages = with pkgs-unstable; [
      # telescope dependencies
      ripgrep
      fd

      # lsp dependencies
      nil
      pyright
      rust-analyzer
      nodePackages.typescript-language-server
      vue-language-server
      vscode-langservers-extracted
      marksman
      lua-language-server
      yaml-language-server

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

      extraConfigLua =
        (builtins.readFile ./init.lua)
        + ''
          lspconfig.ts_ls.setup {
            capabilities = capabilities,
            init_options = {
              plugins = {
                {
                  name = '@vue/typescript-plugin',
                  location = '${pkgs-unstable.vue-language-server}/lib/node_modules/@vue/language-server',
                  languages = { 'vue' },
                },
              },
            },
            filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
          }

          lspconfig.volar.setup {
            capabilities = capabilities,
          }
        '';

      extraPlugins = with pkgs-unstable.vimPlugins; [
        telescope-nvim
        telescope-fzf-native-nvim
        nvim-web-devicons

        nvim-lspconfig
        SchemaStore-nvim

        # cmp
        nvim-cmp
        cmp-treesitter
        cmp-rg
        cmp-nvim-lsp
        cmp-nvim-lsp-signature-help

        vim-surround
        autoclose-nvim

        custom-plugins.improvedft

        custom-plugins.format-on-save-nvim

        custom-plugins.incline-nvim

        harpoon2

        actions-preview-nvim

        gitsigns-nvim

        nvim-hlslens
        vim-fugitive
        vim-flog

        vim-startuptime
      ];
    };
  };
}
