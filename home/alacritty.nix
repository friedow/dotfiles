{ config, pkgs, ... }:
let
  colors = import /etc/nixos/config/colors.nix;
  fonts = import /etc/nixos/config/fonts.nix;
in
{
  programs.alacritty = {
    enable = true;

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
