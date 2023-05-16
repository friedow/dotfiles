{ ... }: {
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    kbdInteractiveAuthentication = false;
    permitRootLogin = "no";
  };

  security.sudo.wheelNeedsPassword = false;

  users.users.christian.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB5Wu0BzLVlygGur8DMjzIV8EeRS8X6MMY2CjYx7g9XD"
  ];
}
