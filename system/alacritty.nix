{ ... }:
let
  colors = import ../config/colors.nix;
  fonts = import ../config/fonts.nix;
in {
  hm.programs.alacritty = {
    enable = builtins.trace "hallo" true;

    settings = {

      # General
      shell.program = "zsh";

      # UI
      colors = {
        primary = {
          foreground = colors.text;
          background = colors.background.primary;
        };

        normal = {
          black = colors.highlight.black;
          blue = colors.highlight.blue;
          cyan = colors.highlight.cyan;
          green = colors.highlight.green;
          magenta = colors.highlight.magenta;
          red = colors.highlight.red;
          yellow = colors.highlight.yellow;
          white = colors.highlight.white;
        };
      };

      cursor.style = {
        shape = "Beam";
        blinking = "On";
      };

      font = {
        size = 9;
        normal.family = fonts.monospace;
      };

      window.padding = {
        x = 12;
        y = 10;
      };
    };
  };
}
