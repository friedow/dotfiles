{ pkgs, ... }:
{
  home-manager.users.christian.home.packages = with pkgs; [ onlyoffice-bin ];
}
