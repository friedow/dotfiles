{ pkgs, lib, ... }: {

  users.users.christian.extraGroups = [ "networkmanager" ];

  networking = {
    useDHCP = lib.mkDefault true;

    networkmanager = { enable = true; };
  };

  programs.nm-applet.enable = true;

  # see https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online = {
    serviceConfig = {
      ExecStart = [ "" "${pkgs.networkmanager}/bin/nm-online -q" ];
    };
  };

}
