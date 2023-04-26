{ pkgs, ... }: {
  systemd.user.services.rofi-git-repositories = {
    script = ''
      #!${pkgs.nushell}/bin/nu

      cd $env.HOME
      glob "[!.]*/**/.git" | save ~/.cache/rofi-git-repositories.txt
    '';
    serviceConfig = { Type = "oneshot"; };
  };

  systemd.user.timers.rofi-git-repositories = {
    wantedBy = [ "timers.target" ];
    timerConfig.OnBootSec = "0m";
    timerConfig.OnUnitActiveSec = "15m";
  };
}
