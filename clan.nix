{ self, inputs, ... }:
{
  imports = [ inputs.clan.flakeModules.default ];
  clan = {
    meta.name = "friedow";
    specialArgs = { inherit self inputs; };
    pkgsForSystem =
      system:
      import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

    secrets.age.plugins = [
      "age-plugin-fido2-hmac"
    ];

    inventory.instances = {
      sshd = {
        module = {
          name = "sshd";
          input = "clan";
        };
        roles = {
          client.tags = [ "all" ];
          server.tags = [ "all" ];
        };
      };
    };
  };

}
