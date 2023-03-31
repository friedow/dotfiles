{ pkgs, lib, ... }: {

  users.users.christian.extraGroups = [ "networkmanager" ];

  networking = {
    useDHCP = lib.mkDefault true;

    networkmanager = {
      enable = true;
      plugins = [ pkgs.networkmanager-openvpn ];
    };
  };

  programs.nm-applet.enable = true;
}
