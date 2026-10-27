{
  flake.modules.nixos.disable-services = {
    services = {
      logrotate.enable = false;
      udisks2.enable = false;
    };
  };
}
