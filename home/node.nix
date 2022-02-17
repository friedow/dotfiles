{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    nodejs-16_x
    gnumake
    gcc
  ];
}
