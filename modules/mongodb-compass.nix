{ pkgs, ... }: {
  home-manager.users.christian.home.packages = [ pkgs.mongodb-compass ];
}
