{ ... }:
{
  # TODO: activate & test these settings
  boot.initrd = {
    systemd.enable = true;
    # verbose = false;
  };
  boot.consoleLogLevel = 0;
  boot.kernelParams = [
    "quiet"
    # "udev.log_level=3"
  ];
  # boot.loader.timeout = 0;
  boot.plymouth.enable = true;
}
