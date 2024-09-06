{ pkgs, ... }:
{
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
    polkit-1.u2fAuth = true;
  };

  # use `udevadm monitor --property` to get the ENV values
  services.udev.extraRules = ''
    ACTION=="remove",ENV{PRODUCT}=="1050/402/556",ENV{INTERFACE}=="3/0/0",RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
  '';
}
