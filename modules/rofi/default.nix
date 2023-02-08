{ pkgs, ... }: 
let 
    fonts = import ../../config/fonts.nix;
    rofi-test-plugin = (pkgs.writeShellScriptBin "rofi-test-plugin" ''
        #!/usr/bin/env bash

        if [ x"$@" = x"quit" ]
        then
            exit 0
        fi
        echo "reload"
        echo "quit"
    '');
in {
    home-manager.users.christian.programs.rofi = {
        enable = true;
        package = pkgs.rofi-wayland;
        font = fonts.monospace;
        terminal = "${pkgs.alacritty}/bin/alacritty";
        plugins = [ ];

        extraConfig = {
            modes = "combi";
            combi-modes = "drun,test:${rofi-test-plugin}/bin/rofi-test-plugin";
        };
    };
}
