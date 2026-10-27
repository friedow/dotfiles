{
  flake.modules.nixos.xdg-utils =
    { pkgs, ... }:
    {
      home-manager.users.christian.home.packages = with pkgs; [ xdg-utils ];
    };
}
