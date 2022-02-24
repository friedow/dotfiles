{ config, pkgs, ... }:
{
  # TODO: comment in when NUR PR is accepted
  # home.packages = with pkgs; [
  #   rofi-lpass
  #   rofi-projects
  # ];

  home.packages = with pkgs.nur.repos.friedow; [
    rofi-lpass
  ];

  programs.rofi = {
    enable = true;
    extraConfig = {
      modi = "window,drun,:/home/christian/Code/friedow/rofi-scripts/rofi-projects.sh,X:/home/christian/Code/friedow/rofi-scripts/rofi-browser.py,C:/home/christian/Code/friedow/rofi-scripts/rofi-calc.sh";
      display-drun = "";
      display-window = "";
      sidebar-mode = true;
    };
    font = "Fira Code 14";
  };
}
