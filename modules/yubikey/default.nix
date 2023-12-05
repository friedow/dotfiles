{ config, pkgs, ... }: {
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
    polkit-1.u2fAuth = true;
  };

  # use `udevadm monitor --property` to get the ENV values
  services.udev.extraRules = ''
    ACTION=="remove", ENV{PRODUCT}=="1050/402/556", ENV{INTERFACE}=="3/0/0", RUN+="${pkgs.fish}/bin/fish -c 'WAYLAND_DISPLAY=wayland-1 XDG_RUNTIME_DIR=/run/user/1001 sudo -u christian -E ${config.lockPackage}/bin/lock &'"
  '';
}
