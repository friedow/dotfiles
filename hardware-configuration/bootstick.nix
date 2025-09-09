{ lib, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-base.nix") ];
  networking.hostName = "bootstick";
  system.stateVersion = "25.05";
  home-manager.users.christian.home.stateVersion = "25.05";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
