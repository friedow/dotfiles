{
  flake.modules.nixos.resource-monitor =
    { ... }:
    {
      home-manager.users.christian.programs.btop.enable = true;
    };
}
