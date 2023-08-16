{ pkgs, ... }:
let
  charite-lg = {
    criteria = "Goldstar Company Ltd BK550Y 901NTDV9Y970";
    scale = 1.0;
    position = "0,0";
  };

  # TODO: restrict this to avalanche's display
  razer-laptop = {
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
        razer-laptop-undocked = { outputs = [ razer-laptop ]; };
        charite-docked = { outputs = [ laptop-off charite-lg ]; };
      };
    };
  };
}
