{ pkgs, ... }: {
  security.polkit.enable = true;

  home-manager.users.christian.systemd.user.services.polkit-gnome-authentication-agent-1 =
    {
      Unit = {
        After = [ "graphical-session-pre.target" ];
        Description = "polkit-gnome-authentication-agent-1";
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart =
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
        Type = "simple";
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };
}
