{ inputs, ... }:
{
  flake.modules.nixos.home-manager =
    { config, ... }:
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.christian.home.stateVersion = config.system.stateVersion;
        extraSpecialArgs = {
          inherit inputs;
        };
      };
    };
}
