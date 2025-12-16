{ pkgs, ... }:
{
  home-manager.users.christian = {

    stylix.targets.nixvim.enable = false;

    programs.nixvim = {
      extraPlugins = [ pkgs.vimPlugins.catppuccin-nvim ];
      extraConfigLuaPre = ''
        require("catppuccin").setup {
          color_overrides = {
            latte = {
              rosewater = "#dc8a78",
              flamingo = "#dd7878",
              pink = "#ea76cb",
              mauve = "#8839ef",
              red = "#d20f39",
              maroon = "#e64553",
              peach = "#fe640b",
              yellow = "#df8e1d",
              green = "#40a02b",
              teal = "#179299",
              sky = "#04a5e5",
              sapphire = "#209fb5",
              blue = "#1e66f5",
              lavender = "#7287fd",

              text = "#565976",
              subtext1 = "#666a85",
              subtext0 = "#787b91",

              overlay2 = "#898c9f",
              overlay1 = "#9a9dac",
              overlay0 = "#aaadbb",

              surface2 = "#babec9",
              surface1 = "#cbced8",
              surface0 = "#dcdee5",

              crust = "#eceff3",
              mantle = "#f6f7f9",
              base = "#ffffff",
            },
          }
        }
        vim.cmd.colorscheme("catppuccin-latte")
      '';
    };
  };
}
