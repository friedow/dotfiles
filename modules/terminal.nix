{ pkgs, ... }:
{
  home-manager.users.christian.programs = {
    kitty = {
      enable = true;

      settings = {
        confirm_os_window_close = 0;
        cursor_blink_interval = 0;
        cursor_shape = "beam";
        window_padding_width = 10;

        "map ctrl+c" = "copy_or_interrupt";
        "map ctrl+v" = "paste_from_clipboard";
      };
    };

    rio = {
      enable = true;
      settings = {
        confirm-before-quit = false;
        padding-x = 10;
        padding-y = [
          10
          10
        ];
      };
    };
  };
}
