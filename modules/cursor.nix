{ pkgs, ... }:
let
  cursor-theme = "Nordzy-cursors";
  cursor-size = 32;
in
{
  # TODO: migrate to theme
  home-manager.users.christian = {
    home.packages = with pkgs; [ nordzy-cursor-theme ];
    home.sessionVariables = {
      XCURSOR_THEME = cursor-theme;
      XCURSOR_SIZE = cursor-size;
    };
    # fix sway cursor size
    wayland.windowManager.sway.config.seat."*" = {
      #  xcursor_theme = "${cursor-theme} ${toString cursor-size}";
      hide_cursor = "when-typing disable";
    };

    gtk.cursorTheme.name = cursor-theme;
    gtk.cursorTheme.size = cursor-size;
  };
}
