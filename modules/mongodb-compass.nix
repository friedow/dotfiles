{ pkgs-unstable, ... }:
{
  # TODO: update unstable as soon as https://github.com/NixOS/nixpkgs/pull/344661 is merged
  home-manager.users.christian.home.packages = [ pkgs-unstable.mongodb-compass ];
  home-manager.users.christian.xdg.desktopEntries."mongodb-compass" = {
    name = "MongoDB Compass";
    genericName = "Database Explorer";
    exec = "mongodb-compass --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland --ignore-additional-command-line-flags";
    terminal = false;
  };
}
