{ config, pkgs, ... }:

let

  charite-lg-left = {
    criteria = "oldstar Company Ltd BK550Y 901NTDV9Y970";
    scale = 1.0;
    position = "0,0";
  };

  charite-lg-right = {
    criteria = "Goldstar Company Ltd BK550Y 004NTVSAL231";
    scale = 1.0;
    transform = "270";
    position = "1920,-500";
  };

  laptop = {
    criteria = "eDP-1";
    scale = 1.5;
    position = "0,0";
  };

  laptop-off = {
    criteria = "eDP-1";
    status = "disable";
  };

in {
  services.kanshi.enable = true;
  services.kanshi.profiles = {
    laptop-undocked = { outputs = [ laptop ]; };
    charite-docked = {
      outputs = [ laptop-off charite-lg-left charite-lg-right ];
    };
  };
}
