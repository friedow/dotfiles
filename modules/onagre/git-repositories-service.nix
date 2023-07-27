{ pkgs, ... }: {
  systemd.user.services.cache-git-repositories = {
    script = ''
      ${pkgs.nushell}/bin/nu -c " \
        cd ~; \
        mkdir ~/.cache/pop-launcher; \
        glob '[!.]*/**/.git' | str replace '/.git$' ' ' | save --force ~/.cache/pop-launcher/git-repositories.txt \
      "
    '';
    serviceConfig = { Type = "oneshot"; };
  };

  systemd.user.timers.cache-git-repositories = {
    wantedBy = [ "timers.target" ];
    timerConfig.OnBootSec = "0m";
    timerConfig.OnUnitActiveSec = "1m";
  };
}
