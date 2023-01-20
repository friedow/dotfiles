{ pkgs, ... }: {
  # enable dbus
  programs.dconf.enable = true;

  # enable gtk
  home-manager.users.christian.gtk = {
    enable = true;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
    };
  };
}
