{ inputs, pkgs, ... }: {
  programs.hyprland.enable = true;
  home-manager.users.christian.wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      exec-once = lock
      exec-once = ${pkgs.swayidle}/bin/swayidle -w lock 'lock' before-sleep 'lock' timeout 300 'lock'

      animation=global,1,2,default
      animation=windowsIn,0

      general:border_size=0
      general:gaps_in=3
      general:gaps_out=3

      decoration:rounding=5
      decoration:dim_inactive=true
      decoration:dim_strength=0.2
      decoration:blur:enabled=false
      decoration:drop_shadow=false

      misc:force_default_wallpaper=0
    '';
    settings = {
      "$mod" = "SUPER";
      bind = [
        "$mod, q, killactive"
        "$mod, Return, exec, kitty"
        "$mod, k, exec, ${inputs.centerpiece.packages.x86_64-linux.default}/bin/centerpiece"

        "$mod, f, fullscreen"

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        "$mod SHIFT, h, movewindow, l"
        "$mod SHIFT, j, movewindow, d"
        "$mod SHIFT, k, movewindow, u"
        "$mod SHIFT, l, movewindow, r"

        "$mod CTRL, h, movecurrentworkspacetomonitor, l"
        "$mod CTRL, j, movecurrentworkspacetomonitor, d"
        "$mod CTRL, k, movecurrentworkspacetomonitor, u"
        "$mod CTRL, l, movecurrentworkspacetomonitor, r"
      ];
    };
  };
}
