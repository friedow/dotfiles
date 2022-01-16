{ config, pkgs, ... }:
let 
  colors = import /etc/nixos/home/colors.nix;
in 
{
	programs.alacritty = {
    enable = true;
    settings = {
      shell.program = "zsh";
      window.padding = {
        x = 12;
        y = 10;
      };
      font = {
        size = 7;
        normal.family = "Fira Code";
      };
      colors.primary.background= "${colors.primary.background}";
    };
  };
}
