{ ... }: {
  boot.initrd.systemd.enable = true;
  boot.consoleLogLevel = 0;
  boot.kernelParams = ["quiet"];
  boot.plymouth = {
    enable = true;
  };
}
