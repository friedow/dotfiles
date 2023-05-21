{ inputs, ... }: {
  imports = [
    inputs.arion.nixosModules.arion
  ];

  virtualisation.arion = {
    backend = "docker";
  };
}
