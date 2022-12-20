{ pkgs, ... }: {
  security.pam.services.login.u2fAuth = true;
  security.pam.services.sudo.u2fAuth = true;
}
