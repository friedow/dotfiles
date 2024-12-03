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

vim.keymap.set("n", "<leader>ca", require("actions-preview").code_actions)
