{ pkgs, ... }:
let
  colors = import ../config/colors.nix;
  fonts = import ../config/fonts.nix;
in {
  home-manager.users.christian.services.dunst = {
    enable = true;
    settings = {
      global = {
        origin = "bottom-right";
        offset = "15x20";
        width = "400";
        height = "120";
        frame_width = "0";
        padding = "10";
        horizontal_padding = "10";
        text_icon_padding = "10";

        vertical_alignment = "top";

        gap_size = "15";

        background = colors.background.inverted;
        foreground = colors.background.secondary;

        timeout = 10;
        font = "JetBrainsMono Nerd Font 10";

        show_indicators = "no";
        min_icon_size = 100;
        max_icon_size = 100;

        browser = "${pkgs.xdg-utils}/bin/xdg-open";
        mouse_left_click = "do_action";
      };

      urgency_normal.timeout = 10;
    };
  };
}
