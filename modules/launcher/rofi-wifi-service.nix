{ pkgs, ... }: {
  systemd.user.services.rofi-wifi = {
    script = ''
      ${pkgs.nushell}/bin/nu -c " \
        ${pkgs.networkmanager}/bin/nmcli device wifi list | save ~/.cache/rofi-wifi.txt \
      "
    '';
    serviceConfig = { Type = "oneshot"; };
  };

  systemd.user.timers.rofi-wifi = {
    wantedBy = [ "timers.target" ];
    timerConfig.OnBootSec = "0m";
    timerConfig.OnUnitActiveSec = "1m";
  };
}
