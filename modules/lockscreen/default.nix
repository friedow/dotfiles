{ pkgs, lib, ... }:
let
  colors = {
    background = {
      primary = "#ffffff";
      secondary = "#f7f6f6";
      inverted = "#000000";
    };

    highlight = {
      black = "#24292e";
      blue = "#0366d6";
      cyan = "#1b7c83";
      green = "#28a745";
      magenta = "#5a32a3";
      red = "#d73a49";
      yellow = "#dbab09";
      white = "#6a737d";
      gray = "#cdc7c2";
    };

  };
  transparent = "#00000000";

  lock = pkgs.writeShellScriptBin "lock" ''
    #!/bin/sh

    ${pkgs.swaylock}/bin/swaylock \
      --color=${colors.background.inverted} \
      \
      --image=/home/christian/.config/swaylock/logo.png \
      --scaling=center \
      \
      --inside-color=${transparent} \
      --inside-clear-color=${transparent} \
      --inside-caps-lock-color=${transparent} \
      --inside-ver-color=${transparent} \
      --inside-wrong-color=${transparent} \
      \
      --text-color=${transparent} \
      --text-clear-color=${transparent} \
      --text-caps-lock-color=${transparent} \
      --text-ver-color=${transparent} \
      --text-wrong-color=${transparent} \
      \
      --indicator-radius=125 \
      --indicator-thickness=5 \
      --ring-color=${colors.background.primary} \
      --separator-color=${colors.background.primary} \
      \
      --key-hl-color=${colors.background.inverted} \
      \
      --daemonize
  '';
in
{
  # include swaylock in pam for it to verify credentials
  security.pam.services.swaylock.text = ''
    auth include login
  '';

  home-manager.users.christian.home = {
    packages = [ lock ];

    file.swaylock-logo-png = {
      source = ./logo.png;
      target = ".config/swaylock/logo.png";
    };
  };
}
