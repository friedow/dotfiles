{ ... }:
let color = import ../config/colors.nix;
in {
  environment.variables.TERM = "alacritty";

  home-manager.users.christian.programs.alacritty = {
    enable = true;

    settings = {

      # General
      shell.program = "fish";

      # UI
      colors = {
        primary = {
          background = "${color.base}"; # base
          foreground = "${color.text}"; # text
          # Bright and dim foreground colors
          dim_foreground = "${color.text}"; # text
          bright_foreground = "${color.text}"; # text
        };

        # Cursor colors
        cursor = {
          text = "${color.base}"; # base
          cursor = "${color.rosewater}"; # rosewater
        };
        vi_mode_cursor = {
          text = "${color.base}"; # base
          cursor = "${color.lavender}"; # lavender
        };

        # Search colors
        search = {
          matches = {
            foreground = "${color.base}"; # base
            background = "${color.subtext0}"; # subtext0
          };
          focused_match = {
            foreground = "${color.base}"; # base
            background = "${color.green}"; # green
          };
          footer_bar = {
            foreground = "${color.base}"; # base
            background = "${color.subtext0}"; # subtext0
          };
        };

        # Keyboard regex hints
        hints = {
          start = {
            foreground = "${color.base}"; # base
            background = "${color.yellow}"; # yellow
          };
          end = {
            foreground = "${color.base}"; # base
            background = "${color.subtext0}"; # subtext0
          };
        };

        # Selection colors
        selection = {
          text = "${color.base}"; # base
          background = "${color.rosewater}"; # rosewater
        };

        # Normal colors
        normal = {
          black = "${color.subtext1}"; # subtext1
          red = "${color.red}"; # red
          green = "${color.green}"; # green
          yellow = "${color.yellow}"; # yellow
          blue = "${color.blue}"; # blue
          magenta = "${color.pink}"; # pink
          cyan = "${color.teal}"; # teal
          white = "${color.surface2}"; # surface2
        };

        # Bright colors
        bright = {
          black = "${color.subtext0}"; # subtext0
          red = "${color.red}"; # red
          green = "${color.green}"; # green
          yellow = "${color.yellow}"; # yellow
          blue = "${color.blue}"; # blue
          magenta = "${color.pink}"; # pink
          cyan = "${color.teal}"; # teal
          white = "${color.surface1}"; # surface1
        };

        # Dim colors
        dim = {
          black = "${color.subtext1}"; # subtext1
          red = "${color.red}"; # red
          green = "${color.green}"; # green
          yellow = "${color.yellow}"; # yellow
          blue = "${color.blue}"; # blue
          magenta = "${color.pink}"; # pink
          cyan = "${color.teal}"; # teal
          white = "${color.surface2}"; # surface2
        };

        indexed_colors = [
          {
            index = 16;
            color = "${color.peach}";
          }
          {
            index = 17;
            color = "${color.rosewater}";
          }
        ];
      };

      cursor.style = { shape = "Beam"; };

      font = { size = 9; };

      window.padding = {
        x = 12;
        y = 10;
      };
    };
  };
}
