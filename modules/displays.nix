{ ... }:
let
  charite-lg-left = {
    criteria = "Goldstar Company Ltd BK550Y 901NTDV9Y970";
    scale = 1.0;
    position = "0,450";
  };

  charite-lg-right = {
    criteria = "Goldstar Company Ltd BK550Y 004NTVSAL231";
    scale = 1.0;
    transform = "270";
    position = "1920,0";
  };

  laptop = {
    criteria = "eDP-1";
    status = "enable";
    scale = 2.0;
    position = "0,0";
  };

  laptop-off = {
    criteria = "eDP-1";
    status = "disable";
  };
in {
  home-manager.users.christian.services.kanshi = {
    enable = true;
    profiles = {
      laptop-undocked = { outputs = [ laptop ]; };
      charite-docked = {
        outputs = [ laptop-off charite-lg-left charite-lg-right ];
      };
    };
  };
}
