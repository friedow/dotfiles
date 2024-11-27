{ pkgs-unstable, ... }:
{
  home-manager.users.christian = {
    home.packages = with pkgs-unstable; [
      ripgrep
      fd
    ];

    programs.nixvim.plugins.telescope = {
      enable = true;
      extensions.fzf-native.enable = true;
    };
  };
}
