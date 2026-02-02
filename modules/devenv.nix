{ pkgs, ... }:
{
  home-manager.users.christian.home.packages = [ pkgs.devenv ];
}
