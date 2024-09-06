{ pkgs, ... }:
{
  # enable dbus
  programs.dconf.enable = true;

  # enable gtk
  home-manager.users.christian = {
    home.packages = with pkgs; [ gtk3 ];

    services.gnome-keyring.enable = true;

    gtk = {
      enable = true;
      iconTheme = {
        name = "Adwaita";
        package = pkgs.gnome.adwaita-icon-theme;
      };
    };
  };
}
