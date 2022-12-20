{ config, pkgs, ... }: {
  home.packages = with pkgs; [ gnome.adwaita-icon-theme gnome.nautilus ];
}
