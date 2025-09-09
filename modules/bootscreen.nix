{ ... }:
{
  # TODO: evaluate whether this is still needed when plymouth is reenabled
  boot.initrd = {
    systemd.enable = true;
    verbose = false;
  };
  boot.consoleLogLevel = 0;
  boot.kernelParams = [
    "quiet"
    "splash"
    "boot.shell_on_fail"
    "loglevel=3"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
  ];
  # boot.loader.timeout = 0;
  boot.plymouth.enable = false;
}
