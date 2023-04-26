{ pkgs, ... }: {
  systemd.user.services.rofi-git-repos = {
    script = ''
      ${pkgs.nushell}/bin/nu -c " \
        cd ~; \
        glob '[!.]*/**/.git' | save ~/.cache/rofi-git-repositories.txt \
      "
    '';
    serviceConfig = { Type = "oneshot"; };
  };

  systemd.user.timers.rofi-git-repos = {
    wantedBy = [ "timers.target" ];
    timerConfig.OnBootSec = "0m";
    timerConfig.OnUnitActiveSec = "15m";
  };
}
