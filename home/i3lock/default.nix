{ config, pkgs, ... }:
let
  colors = import ../../config/colors.nix;
  fonts = import ../../config/fonts.nix;

  transparent = "#00000000";

  lock = pkgs.writeShellScriptBin
    "lock"
    ''
      #!/bin/sh

      i3lock-color \
        --indicator \
        --image=/home/christian/.config/i3lock/logo.png \
        --centered \
        \
        --radius=150 \
        --ring-width=4.0 \
        --color=${colors.background.inverted} \
        \
        --inside-color=${transparent} \
        --ring-color=${colors.background.primary} \
        \
        --insidever-color=${transparent} \
        --ringver-color=${colors.highlight.black} \
        \
        --insidewrong-color=${transparent} \
        --ringwrong-color=${colors.highlight.red} \
        \
        --line-color=${transparent} \
        \
        --keyhl-color=${colors.highlight.black} \
        --bshl-color=${colors.highlight.black} \
        \
        --bshl-color=${transparent} \
        \
        --separator-color=${transparent} \
        \
        --verif-color=${transparent} \
        --wrong-color=${transparent} \
        --modif-color=${transparent} \
        \
        --layout-color=${transparent} \
        --time-color=${transparent} \
        --date-color=${transparent} \
        --greeter-color=${transparent} \
        \
        --verif-text="verifying" \
        --wrong-text="wrong" \
        --noinput-text="empty" \
        --lock-text="locking" \
        --lockfailed-text="lock failed" \
        \
        --verif-font=${fonts.sansSerif} \
        --wrong-font=${fonts.sansSerif}
    '';
in
{
  home.packages = with pkgs; [
    lock
  ];

  home.file.i3lock-logo-png = {
    source = ./logo.png;
    target = ".config/i3lock/logo.png";
  };
}
