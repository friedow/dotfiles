{ pkgs, inputs, ... }:
let
  # TODO: import unstable packages globally
  pkgs-unstable = (import inputs.nixpkgs-unstable) {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
in {
  home-manager.users.christian = {
    home.packages = [
      # telescope dependencies
      pkgs.ripgrep
      pkgs.fd

      # lsp dependencies
      pkgs.nil
      pkgs.nodePackages.typescript-language-server
      pkgs.nodePackages.pyright
      pkgs.rust-analyzer
      pkgs.nodePackages.volar
      pkgs.marksman

      # formatter dependencies
      pkgs-unstable.prettierd
      pkgs.black
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
        -- vim.opt.cmdheight = 0

        vim.opt.tabstop = 2
        vim.opt.shiftwidth = 0 -- uses tabstop if 0
        vim.opt.expandtab = true

        -- keybindings
        vim.g.mapleader = ' '
        vim.keymap.set('n', '<Leader>f', ':Telescope find_files<CR>')
        vim.keymap.set('n', '<Leader>m', ':Telescope marks<CR>')
        vim.keymap.set('n', '<Leader>/', ':Telescope live_grep<CR>')
        vim.keymap.set('n', '<Leader>g', ':Telescope git_files<CR>')
        vim.keymap.set('n', '<Leader>u', ':Telescope undo<CR>')

        -- netrw
        vim.g.netrw_banner = 0
        vim.g.netrw_bufsettings = "noma nomod nonu nobl nowrap ro rnu"
        vim.g.netrw_liststyle = 3

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
          ),
          completion = {
            completeopt = 'menu,menuone,noinsert'
          }
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

        -- Global mappings.
        -- See `:help vim.diagnostic.*` for documentation on any of the below functions
        vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
        vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

        -- Use LspAttach autocommand to only map the following keys
        -- after the language server attaches to the current buffer
        vim.api.nvim_create_autocmd('LspAttach', {
          group = vim.api.nvim_create_augroup('UserLspConfig', {}),
          callback = function(ev)
            -- Enable completion triggered by <c-x><c-o>
            vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

            -- Buffer local mappings.
            -- See `:help vim.lsp.*` for documentation on any of the below functions
            local opts = { buffer = ev.buf }
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
            vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
            vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
            vim.keymap.set('n', '<space>wl', function()
              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, opts)
            vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
            vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
            vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
            vim.keymap.set('n', '<space>f', function()
              vim.lsp.buf.format { async = true }
            end, opts)
          end,
        })

        -- autosave
        vim.api.nvim_create_autocmd({'FocusLost', 'BufLeave'}, {
          command = 'silent! wa'
        })

        -- lsp details and errors on hover
        -- 100ms of no cursor movement to trigger CursorHold
        vim.opt.updatetime = 100
        -- show diagnostic popup on cursor hover
        local diag_float_grp = vim.api.nvim_create_augroup("DiagnosticFloat", { clear = true })
        vim.api.nvim_create_autocmd("CursorHold", {
          callback = function()
            vim.lsp.buf.hover()
            vim.diagnostic.open_float(nil, { focusable = false })
          end,
          group = diag_float_grp,
        })

        require("autoclose").setup()


        package.path = package.path .. ";${inputs.format-on-save-nvim}/lua/?.lua" 
        local format_on_save = dofile("${inputs.format-on-save-nvim}/lua/format-on-save/init.lua")
        local formatters = dofile("${inputs.format-on-save-nvim}/lua/format-on-save/formatters/init.lua")
        format_on_save.setup({
          exclude_path_patterns = {
            "/node_modules/",
          },
          formatter_by_ft = {
            css = formatters.prettierd,
            html = formatters.prettierd,
            javascript = formatters.prettierd,
            json = formatters.prettierd,
            lua = formatters.lsp,
            markdown = formatters.prettierd,
            nix = formatters.shell({ cmd = { "${pkgs.nixfmt}/bin/nixfmt" } }),
            python = formatters.black,
            rust = formatters.lsp,
            scss = formatters.prettierd,
            toml = formatters.prettierd,
            typescript = formatters.prettierd,
            vue = formatters.prettierd,
            yaml = formatters.prettierd,
          },
        })

        -- Lua
        vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end)
        vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
        vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
        vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
        vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
        vim.keymap.set("n", "gr", function() require("trouble").toggle("lsp_references") end)
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

        vim-surround
        autoclose-nvim

        trouble-nvim
      ];
    };
  };
}
