{ config, pkgs, ... }:
{
  # TODO: comment in when NUR PR is accepted
  # packages = [
  #   pkgs.rofi-lpass
  # ];

  programs.rofi = {
    enable = true;
    extraConfig = {
      modi = "window,drun,filebrowser";
      display-drun = "";
      display-window = "";
      sidebar-mode = true;
    };
    font = "Fira Code 14";
  };
}
