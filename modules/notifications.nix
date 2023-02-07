{ ... }:
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
                frame_width = "0";
                padding = "15";
                horizontal_padding = "20";
                
                gap_size = "15";

                background = colors.background.inverted;
                foreground = colors.background.secondary;

                timeout = 10;
                font = "JetBrainsMono Nerd Font 10";
            };

            urgency_normal = {
                timeout = 10;
            };
        };
    };
}

