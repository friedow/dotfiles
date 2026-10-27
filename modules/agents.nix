{ self, ... }:
{
  flake.modules.nixos.agents = {
    home-manager.users.christian = {
      home.packages = [
        self.packages.x86_64-linux.opencode
        self.packages.x86_64-linux.claude-code
      ];
    };
  };
}
