{ pkgs, ... }: {
  home-manager.users.christian.home.packages = with pkgs; [ google-chrome-dev ];
}
