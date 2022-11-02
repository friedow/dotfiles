{ config, pkgs, ... }:
{
  home.file.xfce-keyboard-shortcuts = {
    source = ./xfce4-keyboard-shortcuts.xml;
    target = ".config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml";
  };
}
