{ pkgs, ... }:
{
  home-manager.users.christian.home.packages = with pkgs; [ wl-clipboard ];
}
