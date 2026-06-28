{ pkgs, ... }:
{
  home-manager.users.christian = {

    stylix.targets.nixvim.enable = false;

    programs.nixvim = {
      extraPlugins = [ pkgs.vimPlugins.catppuccin-nvim ];
      extraConfigLua = ''
        require("catppuccin").setup {
          integrations = {
            blink_cmp = true,
            flash = true,
            neogit = true,
            noice = true,
            snacks = true,
          },
          custom_highlights = function(colors)
            return {
              InclineNormal   = { bg = colors.surface0, fg = colors.text },
              InclineNormalNC = { bg = colors.crust,    fg = colors.subtext0 },
              NeoTreeNormal           = { bg = colors.base },
              NeoTreeNormalNC         = { bg = colors.base },
              SnacksPicker            = { bg = colors.base },
              SnacksPickerBorder      = { bg = colors.base },
              SnacksPickerBox         = { bg = colors.base },
              SnacksPickerBoxBorder   = { bg = colors.base },
              SnacksPickerInput       = { bg = colors.base },
              SnacksPickerInputBorder = { bg = colors.base },
            }
          end,
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
