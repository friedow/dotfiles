{ pkgs, ... }: {
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
    polkit-1.u2fAuth = true;
  };

  home-manager.users.christian.home.file.u2f_keys = {
    source = ./u2f_keys;
    target = ".config/Yubico/u2f_keys";
  };
}
