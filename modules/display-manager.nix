{ pkgs, ... }:
let
  home-ultrawide = {
    criteria = "LG Electronics LG ULTRAWIDE 304NTEP5P580";
    scale = 1.5;
    position = "0,0";
    mode = "5120x1440@71.976Hz";
  };

  work-laptop = {
    criteria = "AU Optronics 0xD291 Unknown";
    status = "enable";
    scale = 1.5;
    position = "0,0";
  };

  personal-laptop = {
    criteria = "AU Optronics 0x202B Unknown";
    status = "enable";
    scale = 2.5;
    position = "0,0";
  };

  laptop-off = {
    criteria = "eDP-1";
    status = "disable";
  };
in {
  home-manager.users.christian = {
    home.packages = with pkgs; [ wdisplays ];

    services.kanshi = {
      enable = true;
      profiles = {
        work-laptop-undocked = { outputs = [ work-laptop ]; };
        personal-laptop-undocked = { outputs = [ personal-laptop ]; };
        home-docked = { outputs = [ laptop-off home-ultrawide ]; };
      };
    };
  };
}
