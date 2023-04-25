{ pkgs, ... }:
let

  importRofiPlugin = plugin-name: 
    let plugin-script = import (./. + "/${plugin-name}.nu") pkgs;
    in pkgs.writeScriptBin "${plugin-name}" plugin-script;
  
  rofi-git-repositories = importRofiPlugin "rofi-git-repositories";
  rofi-microphones = importRofiPlugin "rofi-microphones";
  rofi-speakers = importRofiPlugin "rofi-speakers";
  rofi-system-operations = importRofiPlugin "rofi-system-operations";
  rofi-windows = importRofiPlugin "rofi-windows";
in {
  imports = [
    ./rofi-git-repositories-service.nix
  ];

  home-manager.users.christian = {
    home.file.rofi-theme = {
      source = ./theme.rasi;
      target = ".config/rofi/theme.rasi";
    };
  
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      terminal = "${pkgs.alacritty}/bin/alacritty";

      extraConfig = {
        modes = "combi";
        combi-display-format = "{mode}  {text}";
        # continuous scolling
        scroll-method = 1;
        display-drun = "";
        combi-modes = [
          ":${rofi-windows}/bin/rofi-windows"
          "drun"
          ":${rofi-git-repositories}/bin/rofi-git-repositories"
          ":${rofi-speakers}/bin/rofi-speakers"
          ":${rofi-microphones}/bin/rofi-microphones"
          ":${rofi-system-operations}/bin/rofi-system-operations"
        ];
      };

      theme = "theme.rasi";
    };
  };
}
