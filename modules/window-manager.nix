{ pkgs, pkgs-unstable, inputs, config, lib, ... }:
let
  modifier = "Mod4";

  sed-brightnessctl = "sed -En 's/.*\\(([0-9]+)%\\).*/\\1/p'";
  brightness-notification-id = "1";

  brightness-increase = pkgs.writeShellScript "brightnessctl-inc" ''
    current_brightness=$(${pkgs.brightnessctl}/bin/brightnessctl | ${sed-brightnessctl})
    new_brightness=$(echo "(sqrt($current_brightness)+1)^2"|${pkgs.bc}/bin/bc)
    ${pkgs.brightnessctl}/bin/brightnessctl set ''${new_brightness}%
    ${pkgs.libnotify}/bin/notify-send --hint int:value:$new_brightness --replace-id ${brightness-notification-id} "Brightness"
  '';

  brightness-decrease = pkgs.writeShellScript "brightnessctl-dec" ''
    current_brightness=$(${pkgs.brightnessctl}/bin/brightnessctl | ${sed-brightnessctl})
    new_brightness=$(echo "(sqrt($current_brightness)-1)^2"|${pkgs.bc}/bin/bc)
    ${pkgs.brightnessctl}/bin/brightnessctl set ''${new_brightness}%
    ${pkgs.libnotify}/bin/notify-send --hint int:value:$new_brightness --replace-id ${brightness-notification-id} "Brightness"
  '';

  sed-ddccontrol = "sed -En 's/^Control.*\\+\\/([0-9]+)\\/.*/\\1/p'";

  external-brightness-increase =
    pkgs.writeShellScript "external-brightness-increase" ''
      new_brightness=$(${pkgs.ddccontrol}/bin/ddccontrol -r 0x10 -W +10 dev:/dev/i2c-14 | ${sed-ddccontrol})
      ${pkgs.libnotify}/bin/notify-send --hint int:value:$new_brightness --replace-id ${brightness-notification-id} "Brightness"
    '';

  external-brightness-decrease =
    pkgs.writeShellScript "external-brightness-decrease" ''
      new_brightness=$(${pkgs.ddccontrol}/bin/ddccontrol -r 0x10 -W -10 dev:/dev/i2c-14 | ${sed-ddccontrol})
      ${pkgs.libnotify}/bin/notify-send --hint int:value:$new_brightness --replace-id ${brightness-notification-id} "Brightness"
    '';

  volume-notification-id = "2";

  volume-increase = pkgs.writeShellScript "volume-increase" ''
    new_volume=$(${pkgs.pamixer}/bin/pamixer -i 5 --get-volume)
    ${pkgs.libnotify}/bin/notify-send --hint int:value:$new_volume --replace-id ${volume-notification-id} "Volume"
  '';

  volume-decrease = pkgs.writeShellScript "volume-decrease" ''
    new_volume=$(${pkgs.pamixer}/bin/pamixer -d 5 --get-volume)
    ${pkgs.libnotify}/bin/notify-send --hint int:value:$new_volume --replace-id ${volume-notification-id} "Volume"
  '';

  volume-toggle = pkgs.writeShellScript "volume-toggle" ''
    ${pkgs.pamixer}/bin/pamixer -t
    if [ "$(${pkgs.pamixer}/bin/pamixer --get-mute)" = "true" ]; then
      ${pkgs.libnotify}/bin/notify-send --hint int:value:0 --replace-id ${volume-notification-id} "Volume"
    else
      ${pkgs.libnotify}/bin/notify-send --hint int:value:100 --replace-id ${volume-notification-id} "Volume"
    fi
  '';
in {
  services.ddccontrol.enable = true;
  hardware.opengl.enable = true;
  programs.hyprland.enable = true;
  home-manager.users.christian = {

    # Configure most applications to use the wayland interface 
    # natively instead of using the xwayland interface
    home.sessionVariables = {
      XDG_CACHE_HOME = "\${HOME}/.cache";
      XDG_CONFIG_HOME = "\${HOME}/.config";
      XDG_BIN_HOME = "\${HOME}/.local/bin";
      XDG_DATA_HOME = "\${HOME}/.local/share";

      XDG_CURRENT_DESKTOP = "sway";
      XDG_SESSION_DESKTOP = "sway";

      CLUTTER_BACKEND = "wayland";
      ECORE_EVAS_ENGINE = "wayland_egl";
      ELM_ENGINE = "wayland_egl";
      GDK_BACKEND = "wayland";
      # chromium
      NIXOS_OZONE_WL = "1";
      QT_QPA_PLATFORM = "wayland-egl";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      QT_WAYLAND_FORCE_DPI = "physical";
      SDL_VIDEODRIVER = "wayland";
      XDG_SESSION_TYPE = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = "1";
    };

    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = ''
        exec-once = loginctl lock-session
        exec-once = ${pkgs.swayidle}/bin/swayidle -w lock 'lock' before-sleep 'lock' timeout 300 'lock'

        animation=global,1,2,default
        animation=windowsIn,0

        general:border_size=0
        general:gaps_in=3
        general:gaps_out=3

        general:layout=master
        master:orientation=center
        master:mfact=0.5

        decoration:rounding=5
        decoration:dim_inactive=true
        decoration:dim_strength=0.2
        decoration:blur:enabled=false
        decoration:drop_shadow=false

        misc:force_default_wallpaper=0

        monitor=,preferred,auto,1

        # trigger when the switch is turning off
        bindl = , switch:off:Lid Switch,exec,hyprctl keyword monitor "eDP-1,preferred, auto, 1"
        # trigger when the switch is turning on
        bindl = , switch:on:Lid Switch,exec,hyprctl keyword monitor "eDP-1, disable"
      '';
      settings = {
        "$mod" = "SUPER";
        bind = [
          ", XF86MonBrightnessDown, exec, ${brightness-decrease}"
          ", XF86MonBrightnessUp, exec, ${brightness-increase}"
          "$mod, XF86MonBrightnessDown, exec, ${external-brightness-decrease}"
          "$mod, XF86MonBrightnessUp, exec, ${external-brightness-increase}"
          ", XF86AudioRaiseVolume, exec, ${volume-increase}"
          ", XF86AudioLowerVolume, exec, ${volume-decrease}"
          ", XF86AudioMute, exec, ${volume-toggle}"

          "$mod, Return, exec, kitty"
          "$mod, Space, exec, centerpiece"
          "$mod, s, exec, ${pkgs-unstable.hyprshot}/bin/hyprshot --mode region --clipboard-only"

          "$mod, q, killactive"
          "$mod, f, fullscreen"
          "$mod, m, layoutmsg, swapwithmaster master"

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

          "$mod, h, movefocus, l"
          "$mod, j, movefocus, d"
          "$mod, k, movefocus, u"
          "$mod, l, movefocus, r"

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
  };
}
