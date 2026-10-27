{
  flake.modules.nixos.beeper =
    { pkgs, ... }:
    {
      home-manager.users.christian.home.packages = with pkgs; [ beeper ];
    };
}
