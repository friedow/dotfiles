{ self, ... }:
{
  imports = [
    self.modules.nixos.desktop-modules
    self.modules.nixos.work-modules
  ];
}
