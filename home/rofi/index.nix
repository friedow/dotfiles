{ config, pkgs, ... }:
{
  # packages = [
  #   pkgs.rofi-lpass
  # ];

  programs.rofi = {
    enable = true;
    extraConfig = {
      modi = "window,drun";
      display-drun = "";
      display-window = "";
      sidebar-mode = true;
    };
    font = "Fira Code 14";
  };
}
