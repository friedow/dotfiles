# TODO: remove when system search is packaged
{ pkgs, ... }: {
  home-manager.users.christian.home.packages = with pkgs; [ gtk3 ];
}