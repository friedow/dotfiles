{ self, ... }:
{
  users.users.christian.initialPassword = "christian";

  imports = [
    self.modules.nixos.desktop-modules
    self.modules.nixos.personal-modules
  ];
}
