{ pkgs, ... }:
{
  home-manager.users.christian.programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      { id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; } # 1password
    ];
  };

  home-manager.users.christian.xdg.desktopEntries."brave" = {
    name = "Brave";
    genericName = "Browser";
    exec = "brave --enable-features=UseOzonePlatform --ozone-platform=wayland";
    terminal = false;
  };
}
