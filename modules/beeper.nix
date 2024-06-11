{ pkgs-unstable, ... }: {
  home-manager.users.christian.home.packages = [ pkgs-unstable.beeper ];
}
