# TODO: remove when system search is packaged
{ config, pkgs, ... }: {
  home.packages = with pkgs; [ gtk3 ];
}