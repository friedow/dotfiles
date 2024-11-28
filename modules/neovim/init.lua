-- lsp client
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require("lspconfig")
lspconfig.pyright.setup({
	capabilities = capabilities,
})
lspconfig.rust_analyzer.setup({
	capabilities = capabilities,
})
lspconfig.nil_ls.setup({
	capabilities = capabilities,
})
lspconfig.marksman.setup({
	capabilities = capabilities,
})
lspconfig.lua_ls.setup({
	on_init = function(client)
		local path = client.workspace_folders[1].name
		if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
			return
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				-- Tell the language server which version of Lua you're using
				-- (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					-- Depending on the usage, you might want to add additional paths here.
					-- "${3rd}/luv/library"
					-- "${3rd}/busted/library",
				},
				-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
				-- library = vim.api.nvim_get_runtime_file("", true)
			},
		})
	end,
	settings = {
		Lua = {},
	},
})
lspconfig.eslint.setup({
	capabilities = capabilities,
})

lspconfig.yamlls.setup({
	capabilities = capabilities,
	settings = {
		yaml = {
			schemaStore = {
				-- You must disable built-in schemaStore support if you want to use
				-- this plugin and its advanced options like `ignore`.
				enable = false,
				-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
				url = "",
			},
			schemas = require("schemastore").yaml.schemas(),
		},
	},
})

lspconfig.jsonls.setup({
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
		},
	},
})

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions, opts)
		vim.keymap.set("n", "gi", require("telescope.builtin").lsp_implementations, opts)
		vim.keymap.set("n", "<tab>", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<leader><tab>", vim.diagnostic.open_float, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
	end,
})

-- autosave
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
	command = "silent! wa",
})

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
		lua = formatters.stylua,
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
local devicons = require("nvim-web-devicons")
require("incline").setup({
	window = {
		padding = 0,
		margin = { horizontal = 0 },
	},
	render = function(props)
		local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":.")
		if filename == "" then
			filename = "[No Name]"
		end
		local ft_icon = devicons.get_icon(filename)
		return {
			ft_icon and { " ", ft_icon, " " } or "",
			" ",
			{ filename, gui = "bold" },
			" ",
		}
	end,
})

vim.keymap.set("n", "<C-i>", "<C-I>")


vim.keymap.set("n", "gpd", vim.diagnostic.goto_prev)
vim.keymap.set("n", "gnd", vim.diagnostic.goto_next)



vim.keymap.set("n", "<leader>ca", require("actions-preview").code_actions)
