{ pkgs, ... }: {
  systemd.user.services.rofi-git-repositories = {
    script = ''
      #!${pkgs.stdenv.shell}
      set -euo pipefail

      find ~ -not -path '*/.*/.git' -type d -name '.git' | sed 's/^\(.*\/\(.*\)\)\/.git$/\2 \1/' | xargs printf '%s\0info\x1f%s\n' > ~/.cache/rofi-git-repositories.txt
    '';
    serviceConfig = { Type = "oneshot"; };
  };

  systemd.user.timers.rofi-git-repositories = {
    wantedBy = [ "timers.target" ];
    timerConfig.OnBootSec = "0m";
    timerConfig.OnUnitActiveSec = "15m";
  };
}
