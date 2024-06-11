-- general
vim.opt.clipboard = 'unnamedplus'
vim.opt.fillchars='eob: '
vim.opt.mouse = nil;
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.cursorline = true
vim.o.statusline = table.concat({
  '%F ',
  '%h',
  '%m',
  '%r',
  '%=',
  '%P ',
})
-- vim.opt.cmdheight = 0

vim.opt.tabstop = 2
vim.opt.shiftwidth = 0 -- uses tabstop if 0
vim.opt.expandtab = true

-- keybindings
vim.g.mapleader = ' '

-- setup neo-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("neo-tree").setup({
  filesystem = {
    hijack_netrw_behavior = "open_current",
  },
  buffers = {
    follow_current_file = {
      enabled = true,
      leave_dirs_open = true,
    },
    group_empty_dirs = true,
  },
  event_handlers = {
    {
      event = "neo_tree_buffer_enter",
      handler = function(arg)
        -- set neo-tree bg color to white
        vim.cmd.highlight({ "NeoTreeNormal", "guibg=white" })
        vim.cmd [[
          setlocal relativenumber
        ]]
      end,
    }
  },
})
vim.keymap.set('n', '<Leader>e', ':Neotree position=current reveal<CR>')

require('nvim-treesitter.configs').setup {
  highlight = { enable = true },
  indent = { enable = true },
}

-- fuzzy finder
require("telescope").setup({
  extensions = {
    undo = {},
  },
})
require("telescope").load_extension("undo")

vim.keymap.set('n', '<Leader>f', ':Telescope find_files find_command=rg,--files,--hidden,-g,!.git<CR>')
vim.keymap.set('n', '<Leader>m', ':Telescope marks<CR>')
vim.keymap.set('n', '<Leader>k', ':Telescope keymaps<CR>')
vim.keymap.set('n', '<Leader>/', ':Telescope live_grep<CR>')
vim.keymap.set('n', '<Leader>u', ':Telescope undo<CR>')
vim.keymap.set('n', '<leader>q', ':Telescope quickfix<CR>')
vim.keymap.set('n', '<leader>qh', ':Telescope quickfixhistory<CR>')
vim.keymap.set('n', '<leader>ca', require("actions-preview").code_actions)

-- completion menu
require("luasnip.loaders.from_vscode").lazy_load()

local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
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
    {{ name = 'nvim_lsp_signature_help' }},
    {
      { name = 'luasnip' },
      { name = 'nvim_lsp' }
    },
    {{ name = 'rg' }}
  ),
  completion = {
    completeopt = 'menu,menuone,noinsert'
  }
})

-- lsp client
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')
lspconfig.pyright.setup {
  capabilities = capabilities
}
lspconfig.rust_analyzer.setup {
  capabilities = capabilities
}
lspconfig.tsserver.setup {
  capabilities = capabilities
}
lspconfig.volar.setup {
  capabilities = capabilities,
  filetypes = {'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json'}
}
lspconfig.marksman.setup {
  capabilities = capabilities
}

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<tab>', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader><tab>', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  end,
})

-- autosave
vim.api.nvim_create_autocmd({'FocusLost', 'BufLeave'}, {
  command = 'silent! wa'
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
    nix = formatters.shell({ cmd = { "nixfmt" } }),
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
vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle("workspace_diagnostics") end)

require('kitty-scrollback').setup()

local harpoon = require("harpoon")
harpoon:setup()
vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
vim.keymap.set("n", "<C-1>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-2>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-3>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-4>", function() harpoon:list():select(4) end)
vim.keymap.set("n", "<C-J>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-K>", function() harpoon:list():next() end)


require('gitsigns').setup()

require('hlslens').setup()
local kopts = {noremap = true, silent = true}
vim.api.nvim_set_keymap('n', 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', '<Leader>l', '<Cmd>noh<CR>', kopts)

