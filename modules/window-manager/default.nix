{ pkgs, inputs, ... }:
let
  modifier = "Mod4";
  colors = import ../../config/colors.nix;
  fonts = import ../../config/fonts.nix;
  wob_sock = "$XDG_RUNTIME_DIR/wob.sock";

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
  hardware.opengl.enable = true;
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

    # Copy wallpaper image file
    home.file.wallpaper = {
      source = ./wallpaper.png;
      target = ".config/sway/wallpaper.png";
    };

    # Configure sway
    wayland.windowManager.sway = {
      extraSessionCommands = ''
        export WLR_NO_HARDWARE_CURSORS=1
      '';

      enable = true;

      config = {
        # General
        modifier = "${modifier}";

        startup = [
          { command = "lock"; }
          {
            command =
              "rm -f ${wob_sock} && mkfifo ${wob_sock} && tail -f ${wob_sock} | ${pkgs.wob}/bin/wob -o 0 -b 0 -p 1 -H 15 -M 20 -a top";
            always = true;
          }
        ];

        # Keybinds
        keybindings = {
          "${modifier}+q" = "kill";

          "${modifier}+Left" = "focus left";
          "${modifier}+Down" = "focus down";
          "${modifier}+Up" = "focus up";
          "${modifier}+Right" = "focus right";

          "${modifier}+Shift+Left" = "move left";
          "${modifier}+Shift+Down" = "move down";
          "${modifier}+Shift+Up" = "move up";
          "${modifier}+Shift+Right" = "move right";

          "${modifier}+Shift+Ctrl+Left" = "move workspace to output left";
          "${modifier}+Shift+Ctrl+Right" = "move workspace to output right";

          "${modifier}+h" = "split h";
          "${modifier}+v" = "split v";
          "${modifier}+f" = "fullscreen toggle";

          "${modifier}+s" = "layout stacking";
          "${modifier}+w" = "layout tabbed";
          "${modifier}+e" = "layout toggle split";

          "${modifier}+Shift+space" = "floating toggle";

          "${modifier}+a" = "focus parent";

          "${modifier}+1" = "workspace number 1";
          "${modifier}+2" = "workspace number 2";
          "${modifier}+3" = "workspace number 3";
          "${modifier}+4" = "workspace number 4";
          "${modifier}+5" = "workspace number 5";
          "${modifier}+6" = "workspace number 6";
          "${modifier}+7" = "workspace number 7";
          "${modifier}+8" = "workspace number 8";
          "${modifier}+9" = "workspace number 9";
          "${modifier}+0" = "workspace number 10";

          "${modifier}+Shift+1" = "move container to workspace number 1";
          "${modifier}+Shift+2" = "move container to workspace number 2";
          "${modifier}+Shift+3" = "move container to workspace number 3";
          "${modifier}+Shift+4" = "move container to workspace number 4";
          "${modifier}+Shift+5" = "move container to workspace number 5";
          "${modifier}+Shift+6" = "move container to workspace number 6";
          "${modifier}+Shift+7" = "move container to workspace number 7";
          "${modifier}+Shift+8" = "move container to workspace number 8";
          "${modifier}+Shift+9" = "move container to workspace number 9";
          "${modifier}+Shift+0" = "move container to workspace number 10";

          "${modifier}+Shift+c" = "reload";
          "${modifier}+Shift+r" = "restart";

          "${modifier}+r" = "mode resize";

          "${modifier}+Return" = "exec alacritty";
          "${modifier}+Shift+s" = "exec flameshot gui --raw | wl-copy";
          "${modifier}+Shift+p" = ''
            exec ${pkgs.wob}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -p)" -t ppm - | ${pkgs.imagemagick}/bin/convert - -format '%[pixel:p{0,0}]' txt:- | tail -n 1 | cut -d ' ' -f 4 | ${pkgs.wl-clipboard}/bin/wl-copy'';
          "${modifier}+l" = "exec lock";

          "${modifier}+k" =
            "exec ${inputs.centerpiece.packages.x86_64-linux.default}/bin/centerpiece";

          # Brightness
          "--no-repeat --no-warn --locked XF86MonBrightnessDown" =
            "exec ${brightness-decrease}";
          "--no-repeat --no-warn --locked XF86MonBrightnessUp" =
            "exec ${brightness-increase}";

          # Volume
          "--no-repeat --no-warn XF86AudioRaiseVolume" =
            "exec ${volume-increase}";
          "--no-repeat --no-warn XF86AudioLowerVolume" =
            "exec ${volume-decrease}";
          "--no-repeat --no-warn XF86AudioMute" = "exec ${volume-toggle}";

        };

        # UI
        bars = [ ];

        colors = {
          focused = {
            background = colors.background.primary;
            border = colors.background.primary;
            childBorder = colors.highlight.gray;
            indicator = colors.highlight.gray;
            text = colors.text;
          };

          unfocused = {
            background = colors.background.secondary;
            border = colors.highlight.gray;
            childBorder = colors.highlight.gray;
            indicator = colors.highlight.gray;
            text = colors.text;
          };

          focusedInactive = {
            background = colors.background.secondary;
            border = colors.background.secondary;
            childBorder = colors.highlight.gray;
            indicator = colors.highlight.gray;
            text = colors.text;
          };
        };

        floating = {
          border = 0;
          criteria = [{ app_id = "search-friedow-com"; }];
        };

        fonts = {
          names = [ fonts.sansSerif ];
          style = "";
          size = 10.0;
        };

        gaps = {
          inner = 2;
          outer = -2;
        };

        output."*".bg = "~/.config/sway/wallpaper.png fill";

        window = {
          border = 0;

          commands = [{
            command = "titlebar_padding 7 7";
            criteria = { class = ".*"; };
          }];
        };
      };
    };
  };
}
