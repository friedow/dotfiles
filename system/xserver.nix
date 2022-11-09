{ pkgs, ... }: {
  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
    };

    displayManager = {
      defaultSession = "xfce+i3";
      autoLogin.enable = true;
      autoLogin.user = "christian";
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [ i3lock-color ];
    };
    # videoDrivers = [ "nvidia" ];

    libinput.enable = true;
  };
  # hardware.opengl.enable = true;
}
