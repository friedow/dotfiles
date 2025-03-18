{ pkgs, lib, ... }:
{

  users.users.christian.extraGroups = [ "networkmanager" ];

  networking = {
    useDHCP = lib.mkDefault true;

    networkmanager = {
      enable = true;
    };
  };

  systemd.user.services.network-manager-applet = {
    enable = true;
    wants = [
      "niri.service"
    ];
    after = [
      "niri.service"
    ];
    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet";
    };
  };

  # see https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = false;
}
