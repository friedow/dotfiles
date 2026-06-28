{ pkgs, inputs, ... }:
let
  incline-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "incline-nvim";
    src = inputs.incline-nvim;
  };
in
{

  home-manager.users.christian.programs.nixvim = {
    extraPlugins = [ incline-nvim ];

    extraConfigLua = ''
      local devicons = require("nvim-web-devicons")
      require("incline").setup({
        ignore = {
          buftypes = {},
          filetypes = {},
          floating_wins = true,
          unlisted_buffers = false,
          wintypes = {}
        },
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
      			ft_icon and { " ", ft_icon, " " } or "",
      			" ",
      			{ filename, gui = "bold" },
      			" ",
      		}
      	end,
      })
    '';
  };
}
