{ pkgs, config, ... }: {
    systemd.services.rofi-git-repositories = {
        script = ''
            #!${pkgs.stdenv.shell}
            set -euo pipefail

            mkdir -p ${profileDir} ${gcrootsDir}
            chown ${userName}:root ${profileDir} ${gcrootsDir}
        '';
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
            Type = "oneshot";
        };
    };
}