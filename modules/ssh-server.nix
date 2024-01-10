{ ... }: {
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  security.sudo.wheelNeedsPassword = false;

  users.users.christian.openssh.authorizedKeys.keys = [
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAILAzD4Z3COmjM7HeJ+hsxmSe9PK3ywcCcwL8Ql5o5e0EAAAAC3NzaDp5dWJpa2V5"
  ];
}
