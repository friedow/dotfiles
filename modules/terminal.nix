{ ... }:
let
  colors = import ../config/colors.nix;
  fonts = import ../config/fonts.nix;
in {
  environment.variables.TERM = "alacritty";

  home-manager.users.christian.programs.alacritty = {
    enable = true;

    settings = {

      # General
      shell.program = "nu";

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

      font = { size = 9; };

      window.padding = {
        x = 12;
        y = 10;
      };
    };
  };
}
