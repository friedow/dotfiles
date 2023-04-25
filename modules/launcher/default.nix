{ pkgs, stdenv, ... }:
let

  rofi-git-repositories = import ./rofi-git-repositories.nu pkgs;
  rofi-microphones = import ./rofi-microphones.nu pkgs;
  rofi-speakers = import ./rofi-speakers.nu pkgs;
  rofi-system-operations = import ./rofi-system-operations.nu pkgs;
  rofi-windows = import ./rofi-windows.nu pkgs;

  # TODO: Continue packaging all the plugins and using them under rofi.plugins
  texst = stdenv.mkDerivation {};

in {
  imports = [
    ./rofi-git-repositories-service.nix
  ];

  systemd.user.services.rofi-git-repositories = {
    script = ''
      #!${pkgs.stdenv.shell}
      set -euo pipefail

      find ~ -not -path '*/.*/.git' -type d -name '.git' | sed 's/^\(.*\/\(.*\)\)\/.git$/\2 \1/' | xargs printf '%s\0info\x1f%s\n' > ~/.cache/rofi-git-repositories.txt
    '';
    serviceConfig = { Type = "oneshot"; };
  };

  systemd.user.timers.rofi-git-repositories = {
    wantedBy = [ "timers.target" ];
    timerConfig.OnBootSec = "0m";
    timerConfig.OnUnitActiveSec = "15m";
  };

  home-manager.users.christian = {
    home.file.rofi-theme = {
      source = ./theme.rasi;
      target = ".config/rofi/theme.rasi";
    };
  
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      terminal = "${pkgs.alacritty}/bin/alacritty";
      plugins = [ rofi-windows pkgs.rofi-calc ];

      extraConfig = {
        modes = "combi";
        combi-display-format = "{mode}  {text}";
        # continuous scolling
        scroll-method = 1;
        display-drun = "";
        combi-modes =
          ":${rofi-windows}/bin/rofi-windows,drun,:${rofi-git-repositories}/bin/rofi-git-repositories,:${rofi-speakers}/bin/rofi-speakers,:${rofi-microphones}/bin/rofi-microphones,:${rofi-system-operations}/bin/rofi-system-operations";
      };

      theme = "theme.rasi";
    };
  };
}
