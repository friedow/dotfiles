{
  flake.modules.nixos.file-manager =
    { pkgs, ... }:
    {
      home-manager.users.christian.home.packages = with pkgs; [ nautilus ];
    };
}
