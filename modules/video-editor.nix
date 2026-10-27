{
  flake.modules.nixos.video-editor =
    { pkgs, ... }:
    {
      home-manager.users.christian.home.packages = with pkgs; [ kdenlive ];
    };
}
