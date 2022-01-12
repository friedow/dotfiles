{ config, pkgs, ... }:
{
	programs.alacritty = {
    enable = true;
    settings = {
      # shell.program = "/home/christian/.nix-profile/bin/zsh";
      shell.program = "zsh";
      window.padding = {
        x = 12;
        y = 10;
      };
      font = {
        size = 7;
        normal.family = "Fira Code";
      };
    };
  };
}
