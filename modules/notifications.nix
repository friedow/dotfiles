{ pkgs, ... }: {
  home-manager.users.christian.services.dunst = {
    enable = true;
    settings = {
      global = {
        origin = "bottom-right";
        offset = "15x20";
        width = "300";
        height = "95";
        frame_width = "0";
        padding = "10";
        horizontal_padding = "10";
        text_icon_padding = "15";

        vertical_alignment = "top";

        gap_size = "15";
        corner_radius = "3";
        progress_bar_corner_radius = "3";
        icon_corner_radius = "3";

        timeout = 10;

        show_indicators = "no";
        min_icon_size = 75;
        max_icon_size = 75;

        browser = "${pkgs.xdg-utils}/bin/xdg-open";
        mouse_left_click = "do_action";
      };

      urgency_normal.timeout = 10;
    };
  };
}
