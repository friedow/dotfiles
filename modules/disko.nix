{
  inputs,
  pkgs,
  config,
  ...
}:
{
  imports = [ inputs.disko.nixosModules.disko ];

  clan.core.vars.generators.luks = {
    files.key.neededFor = "partitioning";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.xxd
    ];
    script = ''
      dd if=/dev/urandom bs=32 count=1 | xxd -c32 -p > $out/key
    '';
  };

  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-LITEON_CA3-8D512_0029394000SW";
    content = {
      type = "gpt";
      partitions = {
        boot = {
          size = "1G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };

        root = {
          size = "100%";
          content = {
            type = "luks";
            name = "crypted";
            keyFile = "file://${config.clan.core.vars.generators.luks.files.key.path}";
            settings = {
              allowDiscards = true;
            };
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
}
