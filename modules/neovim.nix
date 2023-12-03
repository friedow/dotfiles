{ pkgs, inputs, ... }:
let
  color = import ../config/colors.nix;

  # TODO: import unstable packages globally
  pkgs-unstable = (import inputs.nixpkgs-unstable) {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };

  improvedft = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "improvedft";
    src = pkgs.fetchFromGitHub {
      owner = "chrisbra";
      repo = "improvedft";
      rev = "1f0b78b55ba5fca70db0f584d8b5e56a35fd26f6";
      hash = "sha256-Db1NkRdNNjZoKHpKErNFYI8BBfdX2wCmfohV2uAwVtA=";
    };
  };

  format-on-save-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "format-on-save-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "elentok";
      repo = "format-on-save.nvim";
      rev = "b7ea8d72391281d14ea1fa10324606c1684180da";
      hash = "sha256-y5zAZRuRIQEh6pEj/Aq5+ah2Qd+iNzbZgC5Z5tN1MXw=";
    };
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
        vim.opt.cursorline = true
        -- vim.opt.cmdheight = 0

        vim.opt.tabstop = 2
        vim.opt.shiftwidth = 0 -- uses tabstop if 0
        vim.opt.expandtab = true

        -- keybindings
        vim.g.mapleader = ' '
        vim.keymap.set('n', '<Leader>f', ':Telescope find_files<CR>')
        vim.keymap.set('n', '<Leader>m', ':Telescope marks<CR>')
        vim.keymap.set('n', '<Leader>k', ':Telescope keymaps<CR>')
        vim.keymap.set('n', '<Leader>/', ':Telescope live_grep<CR>')
        vim.keymap.set('n', '<Leader>g', ':Telescope git_files<CR>')
        vim.keymap.set('n', '<Leader>u', ':Telescope undo<CR>')
        vim.keymap.set('n', '<Leader>e', ':Explore<CR>')

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
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
        vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

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
            vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
            vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
            vim.keymap.set('n', '<leader>wl', function()
              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, opts)
            vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
            vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
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
            vim.diagnostic.open_float(nil, { focusable = false })
          end,
          group = diag_float_grp,
        })

        require("autoclose").setup()


        local format_on_save = require("format-on-save")
        local formatters = require("format-on-save.formatters")
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

        require("catppuccin").setup {
          color_overrides = {
            latte = {
              rosewater = "${color.rosewater}",
              flamingo = "${color.flamingo}",
              pink = "${color.pink}",
              mauve = "${color.mauve}",
              red = "${color.red}",
              maroon = "${color.maroon}",
              peach = "${color.peach}",
              yellow = "${color.yellow}",
              green = "${color.green}",
              teal = "${color.teal}",
              sky = "${color.sky}",
              sapphire = "${color.sapphire}",
              blue = "${color.blue}",
              lavender = "${color.lavender}",

              text = "${color.text}",
              subtext1 = "${color.subtext1}",
              subtext0 = "${color.subtext0}",

              overlay2 = "${color.overlay2}",
              overlay1 = "${color.overlay1}",
              overlay0 = "${color.overlay0}",

              surface2 = "${color.surface2}",
              surface1 = "${color.surface1}",
              surface0 = "${color.surface0}",

              crust = "${color.crust}",
              mantle = "${color.mantle}",
              base = "${color.base}",
            },
          }
        }
        vim.cmd.colorscheme("catppuccin-latte")
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

        catppuccin-nvim

        improvedft

        format-on-save-nvim
      ];
    };
  };
}
