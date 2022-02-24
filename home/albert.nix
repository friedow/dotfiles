{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    albert
    wmctrl
    lastpass-cli
    xclip
  ];
}
