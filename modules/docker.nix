{ ... }:
{
  users.users.christian.extraGroups = [ "docker" ];

  virtualisation.docker = {
    enable = true;
    liveRestore = false;
    enableOnBoot = false;
  };
}
