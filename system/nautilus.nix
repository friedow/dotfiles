{ config, pkgs, ... }: {
  home-manager.users.christian.home.packages = with pkgs; [ gnome.adwaita-icon-theme gnome.nautilus ];
}
