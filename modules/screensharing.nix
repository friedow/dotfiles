{ pkgs, ... }: {
  # Enable screensharing in wayland
  xdg = {
    portal = {
      enable = true;
      wlr.enable = true;

      # TODO: do we really need xdg-desktop-portal-gtk?
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      # deprecated, do we need it? 
      # screen sharing seems to work in firefox and chromium without it
      # gtkUsePortal = true;
    };
  };
}
