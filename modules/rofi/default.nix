{ pkgs, config, ... }: 
let 
    fonts = import ../../config/fonts.nix;
    rofi-sway = (pkgs.writeShellScriptBin "rofi-sway" ''
        #!/usr/bin/env bash
        # dependencies:
        # - jq
        # - sway
        #
        # install all dependencies
        # nix shell nixpkgs#jq nixpkgs#sway --command "zsh"

        function listEntries() {
            swaymsg -t get_tree | jq -r '[recurse(.nodes[])] | map(select(.type == "con") | [ .name, .id ] | @sh) | .[] ' | xargs printf '%s\0info\x1f%s\n'
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

    rofi-git-repositories = (pkgs.writeShellScriptBin "rofi-git-repositories" ''
        #!/usr/bin/env bash
        # dependencies:
        # - locate (use nix-locate)
        # - sway
        #
        # install all dependencies
        # nix shell nixpkgs#jq nixpkgs#sway --command "zsh"

        function listEntries() {
            # todo: write an index file
            cat ~/.cache/rofi-git-repositories.txt
        }

        function executeEntryAction() {
            coproc ( code "$ROFI_INFO"  > /dev/null  2>&1 )
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
    systemd.user.services.rofi-git-repositories = {
        script = ''
            #!${pkgs.stdenv.shell}
            set -euo pipefail

            find ~ -not -path '*/.*/.git' -type d -name '.git' | sed 's/^\(.*\/\(.*\)\)\/.git$/\2 \1/' | xargs printf '%s\0info\x1f%s\n' > ~/.cache/rofi-git-repositories.txt
        '';
        serviceConfig = {
            Type = "oneshot";
        };
    };

    systemd.user.timers.rofi-git-repositories = {
        wantedBy = [ "timers.target" ];
        timerConfig.OnBootSec = "0m";
        timerConfig.OnUnitActiveSec = "15m";  
    };

    home-manager.users.christian = {
        
        home.packages = with pkgs; [
            # rofi-sway
            jq

            # rofi-git-repositories
            # busybox #(sed, xargs)
            # vscode
        ];
        
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
            combi-modes = ":${rofi-sway}/bin/rofi-sway,drun,:${rofi-git-repositories}/bin/rofi-git-repositories";
            # combi-modes = "drun";
        };

        theme = "theme.rasi";
    };
}
