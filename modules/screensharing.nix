{ pkgs, ... }: {
  # Enable screensharing in wayland
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    config.common.default = [ "wlr" "gtk" ];

    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };
}
