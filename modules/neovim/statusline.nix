{ pkgs-unstable, ... }:
let
  incline-nvim = pkgs-unstable.vimUtils.buildVimPlugin {
    name = "incline-nvim";
    src = pkgs-unstable.fetchFromGitHub {
      owner = "b0o";
      repo = "incline.nvim";
      rev = "27040695b3bbfcd3257669037bd008d1a892831d";
      hash = "sha256-5chrEfjk1Q+lvGqtoUfS/cYbxCUp1gij6SMoB1QRNbs=";
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
