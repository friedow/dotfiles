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
