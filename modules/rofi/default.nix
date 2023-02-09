{ pkgs, ... }: 
let 
    fonts = import ../../config/fonts.nix;
    rofi-test-plugin = (pkgs.writeShellScriptBin "rofi-test-plugin" ''
        #!/usr/bin/env bash
        # dependencies:
        # - jq
        # - sway
        #
        # install all dependencies
        # nix shell nixpkgs#jq nixpkgs#sway --command "zsh"

        function listEntries() {
            swaymsg -t get_tree | jq -r '[recurse(.nodes[])] | map(select(.type == "con")) | map([ .name, .id ]) | map(@sh) | .[] ' | xargs printf '%s\0info\x1f%s\n'
        }

        function executeEntryAction() {
            coproc ( swaymsg "[con_id=$ROFI_INFO]" focus  > /dev/null  2>&1 )
        }

        function main() {
            local selectedEntry=$1

            if [[ -z $selectedEntry ]]; then
                listEntries
            else
                executeEntryAction $selectedEntry
            fi
        }

        main "$@"
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
