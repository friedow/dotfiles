{ config, pkgs, ... }:
let
  colors = import ../../config/colors.nix;
  fonts = import ../../config/fonts.nix;

  transparent = "#00000000";

  lock = pkgs.writeShellScriptBin "lock" ''
    #!/bin/sh

    swaylock \
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
      --indicator-radius=150 \
      --indicator-thickness=5 \
      --ring-color=${colors.background.primary} \
      --separator-color=${colors.background.primary} \
      \
      --key-hl-color=${colors.background.inverted}
  '';
in {
  home.packages = with pkgs; [ swaylock lock ];

  home.file.swaylock-logo-png = {
    source = ./logo.png;
    target = ".config/swaylock/logo.png";
  };
}
