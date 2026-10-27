{
  flake.modules.nixos.devenv =
    { pkgs, ... }:
    {
      home-manager.users.christian.home.packages = [ pkgs.devenv ];
    };
}
