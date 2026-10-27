{
  flake.modules.nixos.clipboard =
    { pkgs, ... }:
    {
      home-manager.users.christian.home.packages = [ pkgs.wl-clipboard ];
    };
}
