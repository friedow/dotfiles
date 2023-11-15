{ pkgs, ... }: {
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
      extraLuaConfig = ''
        -- general
        vim.opt.clipboard = 'unnamedplus'
        vim.opt.fillchars='eob: '
        vim.opt.mouse = nil;
        vim.opt.number = true
        vim.opt.relativenumber = true
        vim.opt.scrolloff = 8
        
        -- keybindings
        vim.g.mapleader = ' '
        vim.keymap.set('n', '<Leader>f', ':Telescope find_files<CR>')
        vim.keymap.set('n', '<Leader>m', ':Telescope marks<CR>')
        vim.keymap.set('n', '<Leader>/', ':Telescope live_grep<CR>')
        vim.keymap.set('n', '<Leader>g', ':Telescope git_files<CR>')
        vim.keymap.set('n', '<Leader>u', ':Telescope undo<CR>')

        -- fuzzy finder
        require("telescope").setup({
          extensions = {
            undo = {},
          },
        })
        require("telescope").load_extension("undo")

        -- completion menu
        local cmp = require'cmp'
        cmp.setup({
          window = {
            -- completion = cmp.config.window.bordered(),
            -- documentation = cmp.config.window.bordered(),
          },
          mapping = cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }), 
            ['<Tab>'] = cmp.mapping.confirm({ select = true }), 
          }),
          sources = cmp.config.sources(
            {{ name = 'nvim_lsp' }},
            {{ name = 'rg' }}
          )
        })

        -- lsp client
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        local lspconfig = require('lspconfig')
        lspconfig.nil_ls.setup {
          capabilities = capabilities
        }
        lspconfig.tsserver.setup {
          capabilities = capabilities
        }
        lspconfig.pyright.setup {
          capabilities = capabilities
        }
        lspconfig.rust_analyzer.setup {
          capabilities = capabilities
        }
        lspconfig.volar.setup {
          capabilities = capabilities
        }
        lspconfig.marksman.setup {
          capabilities = capabilities
        }
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

        nvim-cmp
        cmp-treesitter
        cmp-rg
        cmp-nvim-lsp
      ];
    };
  };
}
