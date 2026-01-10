{ self, ... }:
{
  imports = [
    self.modules.nixos.desktop-modules
    self.modules.nixos.work-modules
    ../../hardware-configuration/tsunami.nix
  ];
}
