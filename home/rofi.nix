{ config, pkgs, ... }:
{
  # TODO: comment in when NUR PR is accepted
  # home.packages = with pkgs; [
  #   rofi-lpass
  #   rofi-projects
  # ];

  programs.rofi = {
    enable = true;
    extraConfig = {
      modi = "window,drun,:/home/christian/Code/friedow/rofi-scripts/rofi-projects.sh";
      display-drun = "";
      display-window = "";
      sidebar-mode = true;
    };
    font = "Fira Code 14";
  };
}
