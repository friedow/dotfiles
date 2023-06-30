{ inputs, pkgs, ... }: {
  home-manager.users.christian.home.packages = [ inputs.akenji-dotfiles.nixosModules.home.onagre pkgs.papirus-icon-theme ];
}