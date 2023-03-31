{ config, pkgs, ... }: {
  home-manager.users.christian.home.packages = with pkgs; [ gnome.nautilus ];
}
