{ pkgs, ... }:
let
  fonts = import ../../config/fonts.nix;

  rofi-microphones = import ./rofi-microphones.nu pkgs;
  rofi-speakers = import ./rofi-speakers.nu pkgs;
  rofi-system-operations = import ./rofi-system-operations.nu pkgs;
  rofi-windows = import ./rofi-windows.nu pkgs;
  rofi-git-repositories = import ./rofi-git-repositories.nu pkgs;

in {
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
    home.packages = with pkgs; [ jq ];

    home.file.rofi-theme = {
      source = ./theme.rasi;
      target = ".config/rofi/theme.rasi";
    };
  };

  home-manager.users.christian.programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    terminal = "${pkgs.alacritty}/bin/alacritty";
    plugins = [ ];

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
}
