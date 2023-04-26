{ pkgs, inputs, ... }:
let

  # TODO: import unstable packages globally
  pkgs-unstable = (import inputs.nixpkgs-unstable) {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };

  importRofiPlugin = plugin-name: 
    let plugin-script = import (./. + "/${plugin-name}.nu") pkgs-unstable;
    in pkgs.writeScriptBin "${plugin-name}" plugin-script;
  
  rofi-git-repositories = importRofiPlugin "rofi-git-repositories";
  rofi-microphones = importRofiPlugin "rofi-microphones";
  rofi-speakers = importRofiPlugin "rofi-speakers";
  rofi-system-operations = importRofiPlugin "rofi-system-operations";
  rofi-windows = importRofiPlugin "rofi-windows";
  rofi-wifi = importRofiPlugin "rofi-wifi";
in {
  imports = [
    ./rofi-git-repositories-service.nix
    ./rofi-wifi-service.nix
  ];

  home-manager.users.christian = {
    home.packages = [ rofi-wifi ];

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
          ":${rofi-wifi}/bin/rofi-wifi"
        ];
      };

      theme = "theme.rasi";
    };
  };
}
