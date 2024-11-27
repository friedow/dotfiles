{ pkgs-unstable, ... }:
{
  home-manager.users.christian.programs.nixvim.plugins = {
    gitsigns.enable = true;
  };
}
