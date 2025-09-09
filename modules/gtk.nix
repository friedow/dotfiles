{ pkgs, ... }:
{
  # enable dbus
  programs.dconf.enable = true;

  # enable gtk
  home-manager.users.christian = {
    # TODO: check whether this is still needed when stylix is enabled
    home.packages = with pkgs; [ gtk3 ];

    # TODO: check whether this is still needed. I think this was vscode extensions depending on it.
    services.gnome-keyring.enable = true;

    # TODO: check whether this is still needed when stylix is enabled
    gtk = {
      enable = true;
      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
    };
  };
}
