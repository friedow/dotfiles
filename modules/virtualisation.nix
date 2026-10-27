{
  flake.modules.nixos.virtualisation = {
    boot.enableContainers = true;
    virtualisation.containers.enable = true;
  };
}
