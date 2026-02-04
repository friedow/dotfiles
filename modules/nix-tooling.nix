{ pkgs, pkgs-unstable, ... }:
{
  home-manager.users.christian.home.packages = [
    pkgs.gh
    pkgs.nixpkgs-review
    pkgs.nix-output-monitor
    pkgs-unstable.flake-edit
  ];
}
