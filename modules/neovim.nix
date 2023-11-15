{ pkgs, inputs, ... }: {
  home-manager.users.christian = {
    home.packages = with pkgs; [
      # telescope dependencies
      ripgrep
      fd

      # lsp dependencies
      nil
      nodePackages.typescript-language-server
      nodePackages.pyright
      rust-analyzer
      nodePackages.volar
      marksman
    ];
    programs.neovim = {
      enable = true;
      defaultEditor = false;
      viAlias = true;
      vimAlias = true;
      extraConfig = ''
        set number relativenumber
        set mouse=
        set clipboard+=unnamedplus
        set fillchars=eob:\
        set scrolloff=8

        let mapleader = " "
        nnoremap <leader>ff <cmd>Telescope find_files<cr>
        nnoremap <leader>fm <cmd>Telescope marks<cr>
        nnoremap <leader>fe <cmd>Telescope live_grep<cr>
        nnoremap <leader>fg <cmd>Telescope git_files<cr>
        nnoremap <leader>u <cmd>lua require("telescope").extensions.undo.undo()<cr>
      '';
      extraLuaConfig = ''

        local lspconfig = require('lspconfig')
        lspconfig.nil_ls.setup {}
        lspconfig.tsserver.setup {}
        lspconfig.pyright.setup {}
        lspconfig.rust_analyzer.setup {}
        lspconfig.volar.setup {}
        lspconfig.marksman.setup {}
      '';
      plugins = with pkgs.vimPlugins; [
        telescope-nvim
        telescope-fzf-native-nvim
        nvim-web-devicons
        telescope-undo-nvim

        (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
          p.nix
          p.typescript
          p.rust
          p.javascript
          p.python
          p.markdown
          p.html
          p.vue
          p.css
          p.scss
          p.yaml
          p.toml
          p.json
        ]))

        nvim-lspconfig
      ];
    };
  };
}
