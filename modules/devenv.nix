{ pkgs, ... }:
{
  # TODO: see if there is a devenv option in home manager
  home-manager.users.christian.home.packages = with pkgs; [
    devenv
  ];
}
