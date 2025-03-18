{ pkgs, ... }:
{
  home-manager.users.christian.programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      { id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; } # 1password
      { id = "fihnjjcciajhdojfnbdddfaoknhalnja"; } # i dont care about cookies
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      { id = "nhdogjmejiglipccpnnnanhbledajbpd"; } # vue.js devtools
    ];
  };

  home-manager.users.christian.xdg.desktopEntries."brave" = {
    name = "Brave";
    genericName = "Browser";
    exec = "brave --enable-features=UseOzonePlatform --ozone-platform=wayland";
    terminal = false;
  };
}
