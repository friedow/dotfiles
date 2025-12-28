{
  # config,
  # pkgs,
  ...
}:
{
  # clan.core.vars.generators.luks = {
  #   files.key.neededFor = "partitioning";
  #   runtimeInputs = [
  #     pkgs.coreutils
  #     pkgs.xxd
  #   ];
  #   script = ''
  #     dd if=/dev/urandom bs=32 count=1 | xxd -c32 -p > $out/key
  #   '';
  # };

  boot.loader.grub.devices = [ "nodev" ];

  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;

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
            passwordFile = "/tmp/secret.key"; # Interactive
            settings = {
              allowDiscards = true;
              # keyFile = "file://${config.clan.core.vars.generators.luks.files.key.path}";
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
