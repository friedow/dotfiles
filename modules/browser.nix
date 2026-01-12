{ pkgs, ... }:
{
  home-manager.users.christian = {
    programs.chromium = {
      enable = true;
      package = pkgs.brave;
      extensions = [
        { id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; } # 1password
        { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # vimium
        { id = "iaiomicjabeggjcfkbimgmglanimpnae"; } # Tab Session Manager
        { id = "aghdiknflpelpkepifoplhodcnfildao"; } # Save Tab Groups for Tab Session Manager
      ];
    };

    xdg.desktopEntries."brave" = {
      name = "Brave";
      genericName = "Browser";
      exec = "brave --enable-features=UseOzonePlatform --ozone-platform=wayland";
      terminal = false;
    };
  };
}
