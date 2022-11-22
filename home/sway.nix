{ config, pkgs, ... }:
let
  modifier = "Mod4";
  colors = import ../config/colors.nix;
  fonts = import ../config/fonts.nix;
in {
  # Configure most applications to use the wayland interface 
  # natively instead of using the xwayland interface
  home.sessionVariables = {
    XDG_CACHE_HOME = "\${HOME}/.cache";
    XDG_CONFIG_HOME = "\${HOME}/.config";
    XDG_BIN_HOME = "\${HOME}/.local/bin";
    XDG_DATA_HOME = "\${HOME}/.local/share";

    XDG_CURRENT_DESKTOP = "sway";
    EDITOR = "vim";

    CLUTTER_BACKEND = "wayland";
    ECORE_EVAS_ENGINE = "wayland_egl";
    ELM_ENGINE = "wayland_egl";
    GDK_BACKEND = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    # chromium
    # NIXOS_OZONE_WL = "1"; 
    QT_QPA_PLATFORM = "wayland-egl";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_WAYLAND_FORCE_DPI = "physical";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  # Copt wallpaper image file
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
            "/home/christian/Code/friedow/search/src-tauri/target/release/search-friedow-com";
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
        "${modifier}+Shift+s" = "exec flameshot gui";
        "${modifier}+l" = "exec lock";

        # Brightness
        "--no-repeat --no-warn --locked XF86MonBrightnessDown" =
          "exec ${pkgs.brightnessctl}/bin/brightnessctl set 10%-";
        "--no-repeat --no-warn --locked XF86MonBrightnessUp" =
          "exec ${pkgs.brightnessctl}/bin/brightnessctl set +10%";

        # Volume
        "--no-repeat --no-warn XF86AudioRaiseVolume" =
          "exec ${pkgs.pamixer}/bin/pamixer -i 5";
        "--no-repeat --no-warn XF86AudioLowerVolume" =
          "exec ${pkgs.pamixer}/bin/pamixer -d 5";
        "--no-repeat --no-warn XF86AudioMute" =
          "exec ${pkgs.pamixer}/bin/pamixer -t";

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
        criteria = [{ class = "Search-friedow-com"; }];
      };

      fonts = {
        names = [ fonts.sansSerif ];
        style = "";
        size = 15.0;
      };

      gaps = {
        inner = 2;
        outer = -2;
      };

      output = { "*" = { bg = "~/.config/sway/wallpaper.png fill"; }; };

      window = {
        border = 0;

        commands = [{
          command = ''title_format "<span size='9pt'>    %title</span>"'';
          criteria = { class = ".*"; };
        }];
      };
    };
  };
}
