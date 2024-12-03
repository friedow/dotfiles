{ pkgs-unstable, ... }:
let
  incline-nvim = pkgs-unstable.vimUtils.buildVimPlugin {
    name = "incline-nvim";
    src = pkgs-unstable.fetchFromGitHub {
      owner = "b0o";
      repo = "incline.nvim";
      rev = "16fc9c073e3ea4175b66ad94375df6d73fc114c0";
      hash = "sha256-5DoIvIdAZV7ZgmQO2XmbM3G+nNn4tAumsShoN3rDGrs=";
    };
  };
in
{

  home-manager.users.christian.programs.nixvim = {
    extraPlugins = [ incline-nvim ];

    extraConfigLua = ''
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
    '';
  };
}
