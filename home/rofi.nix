{ config, pkgs, ... }:
{
  # TODO: use for all custom packages
  home.packages = with pkgs.nur.repos.friedow; [
    rofi-lpass
  ];

  programs.rofi = {
    enable = true;
    extraConfig = {
      modi = "window,drun,:/home/christian/Code/friedow/rofi-scripts/rofi-projects.sh,combi";
      display-drun = "";
      display-window = "";
      sidebar-mode = true;
      combi-modes = "window,drun,";
    };
    font = "Fira Code 14";
  };
}
