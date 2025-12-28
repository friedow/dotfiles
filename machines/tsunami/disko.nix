{ inputs, ... }:
{
  boot.loader.grub = {
    devices = [ "nodev" ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  disko.devices.disk.main = {
    type = "disk";
    # TODO: change to disk by-id
    device = "/dev/disk/by-id/nvme0n1";
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
