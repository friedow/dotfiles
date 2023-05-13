{ pkgs, ... }: {
  # Enable screensharing in wayland
  xdg.portal = {
    enable = true;
    wlr.enable = true;

    extraPortals = with pkgs; [ xdg-desktop-portal-wlr xdg-desktop-portal-gtk ];
  };
}
