{ pkgs-unstable, ... }:
{
  home-manager.users.christian.programs.kitty = {
    enable = true;
    package = pkgs-unstable.kitty;

    shellIntegration.enableFishIntegration = true;

    settings = {
      confirm_os_window_close = 0;
      cursor_blink_interval = 0;
      cursor_shape = "beam";
      window_padding_width = 10;

      "map ctrl+c" = "copy_or_interrupt";
    };
  };
}
