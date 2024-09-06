{ pkgs, ... }:
{
  virtualisation.virtualbox.host.enable = true;
  environment.systemPackages = [ pkgs.vagrant ];
  users.users.christian.extraGroups = [ "vboxusers" ];
}
