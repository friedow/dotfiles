{
  flake.modules.nixos.glab =
    { pkgs, ... }:
    {
      home-manager.users.christian.home.packages = [ pkgs.glab ];
    };
}
