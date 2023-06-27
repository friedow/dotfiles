{ inputs, ... }:
let
  pkgs-onagre-fix = (import inputs.nixpkgs-onagre-fix) {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
in {
  home-manager.users.christian.home.packages = [ pkgs-onagre-fix.onagre ];
}