{
  pkgs,
  pkgs-unstable,
  lib,
  inputs,
  ...
}:
let
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

  external-brightness-increase = pkgs.writeShellScript "external-brightness-increase" ''
    new_brightness=$(${pkgs.ddccontrol}/bin/ddccontrol -r 0x10 -W +10 dev:/dev/i2c-14 | ${sed-ddccontrol})
    ${pkgs.libnotify}/bin/notify-send --hint int:value:$new_brightness --replace-id ${brightness-notification-id} "Brightness"
  '';

  external-brightness-decrease = pkgs.writeShellScript "external-brightness-decrease" ''
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

  create-screenshot = pkgs.writeShellScript "create-screenshot" ''
    ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.swappy}/bin/swappy -f -
  '';

  niri = inputs.niri.packages.x86_64-linux.default;
in
{
  services.ddccontrol.enable = true;
  hardware.opengl.enable = true;

  systemd.user.extraConfig = ''
    DefaultEnvironment="PATH=$PATH:/run/current-system/sw/bin:/etc/profiles/per-user/%u/bin:/run/wrappers/bin"
  '';

  systemd.user.services.niri = {
    description = "A scrollable-tiling Wayland compositor";
    bindsTo = [ "graphical-session.target" ];
    before = [
      "xdg-desktop-autostart.target"
      "graphical-session.target"
    ];
    wants = [
      "xdg-desktop-autostart.target"
      "graphical-session-pre.target"
    ];
    after = [ "graphical-session-pre.target" ];
    environment = lib.mkForce { };
    serviceConfig = {
      Slice = "session.slice";
      Type = "notify";
      ExecStart = "${niri}/bin/niri --session";
    };
  };

  xdg = {
    portal = {
      enable = true;
      config.niri.default = "gnome;";
      extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    };
  };

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

    home.packages = [ niri ];

    home.file.".config/niri/config.kdl".text = ''
      spawn-at-startup "lock"
      spawn-at-startup "${pkgs.swayidle}/bin/swayidle -w lock 'lock' before-sleep 'lock' timeout 300 'lock'"
      spawn-at-startup "${pkgs.swaybg}/bin/swaybg --image ${./theme/wallpaper.png}"

      input {
          warp-mouse-to-focus
          //focus-follows-mouse max-scroll-amount="0%"
          workspace-auto-back-and-forth

          keyboard {
              repeat-rate 35
              repeat-delay 350

              xkb {
                  layout "us"
                  options "ctrl:nocaps,compose:ralt"
              }
          }
          touchpad {
              click-method "clickfinger"
          }
          mouse {
            // TODO: speed
          }
      }

      output "AU Optronics 0x202B" {
          scale 2
      }

      prefer-no-csd

      screenshot-path "~/tmp/screenshot-%Y%m%d%H%M%S.png"

      hotkey-overlay {
        skip-at-startup
      }


      layout {
          gaps 10

          center-focused-column "always"

          default-column-width { 
            proportion 0.30
            //proportion 0.50
            //fixed 800
          }

          preset-column-widths {
              //fixed 800
              //fixed 1100
              //fixed 1400
              proportion 0.30
              proportion 0.45
              proportion 0.60
          }

          focus-ring {
              off
          }

          border {
              off
          }

          struts {
          }
      }

      animations {
      }

      window-rule {
          geometry-corner-radius 5
          clip-to-geometry true
      }

      binds {
          Mod+Shift+Slash { show-hotkey-overlay; }
          Mod+Return { spawn "${pkgs.kitty}/bin/kitty"; }
          Mod+Space { spawn "centerpiece"; }
          Mod+Q { close-window; }

          XF86AudioRaiseVolume  allow-when-locked=true { spawn "${volume-increase}"; }
          XF86AudioLowerVolume  allow-when-locked=true { spawn "${volume-decrease}"; }
          XF86AudioMute         allow-when-locked=true { spawn "${volume-toggle}"; }
          XF86MonBrightnessDown allow-when-locked=true { spawn "${brightness-decrease}"; }
          XF86MonBrightnessUp   allow-when-locked=true { spawn "${brightness-increase}"; }
          Mod+XF86MonBrightnessDown allow-when-locked=true { spawn "${external-brightness-decrease}"; }
          Mod+XF86MonBrightnessUp   allow-when-locked=true { spawn "${external-brightness-increase}"; }

          Mod+H     { focus-column-or-monitor-left; }
          Mod+J  { focus-window-or-workspace-down; }
          Mod+K  { focus-window-or-workspace-up; }
          Mod+L     { focus-column-or-monitor-right; }

          Mod+Shift+H     { move-column-left-or-to-monitor-left; }
          Mod+Shift+J  { move-window-down-or-to-workspace-down; }
          Mod+Shift+K  { move-window-up-or-to-workspace-up; }
          Mod+Shift+L     { move-column-right-or-to-monitor-right; }

          Mod+Ctrl+H { focus-monitor-left; }
          Mod+Ctrl+J { focus-monitor-down; }
          Mod+Ctrl+K { focus-monitor-up; }
          Mod+Ctrl+L { focus-monitor-right; }

          Mod+Shift+Ctrl+H     { move-column-to-monitor-left; }
          Mod+Shift+Ctrl+J     { move-column-to-workspace-down; }
          Mod+Shift+Ctrl+K     { move-column-to-workspace-up; }
          Mod+Shift+Ctrl+L     { move-column-to-monitor-right; }

          Mod+Shift+Alt+Ctrl+H     { move-workspace-to-monitor-left; }
          Mod+Shift+Alt+Ctrl+J     { move-workspace-down; }
          Mod+Shift+Alt+Ctrl+K     { move-workspace-up; }
          Mod+Shift+Alt+Ctrl+L     { move-workspace-to-monitor-right; }

          Mod+1 { focus-workspace 1; }
          Mod+2 { focus-workspace 2; }
          Mod+3 { focus-workspace 3; }
          Mod+4 { focus-workspace 4; }
          Mod+5 { focus-workspace 5; }
          Mod+6 { focus-workspace 6; }
          Mod+7 { focus-workspace 7; }
          Mod+8 { focus-workspace 8; }
          Mod+9 { focus-workspace 9; }
          Mod+0 { focus-workspace 10; }

          Mod+Shift+1 { move-window-to-workspace "1"; }
          Mod+Shift+2 { move-window-to-workspace "2"; }
          Mod+Shift+3 { move-window-to-workspace "3"; }
          Mod+Shift+4 { move-window-to-workspace "4"; }
          Mod+Shift+5 { move-window-to-workspace "5"; }
          Mod+Shift+6 { move-window-to-workspace "6"; }
          Mod+Shift+7 { move-window-to-workspace "7"; }
          Mod+Shift+8 { move-window-to-workspace "8"; }
          Mod+Shift+9 { move-window-to-workspace "9"; }
          Mod+Shift+0 { move-window-to-workspace "0"; }

          Mod+Comma  { consume-window-into-column; }
          Mod+Period { expel-window-from-column; }
          Mod+R { switch-preset-column-width; }
          Mod+F { maximize-column; }
          Mod+C { center-column; }
          Mod+Minus { set-column-width "-10%"; }
          Mod+Equal { set-column-width "+10%"; }
          Print { screenshot; }
          Ctrl+Print { screenshot-screen; }
          Alt+Print { screenshot-window; }
      }
    '';
  };
}
