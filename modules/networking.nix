{ pkgs, lib, ... }: {

  users.users.christian.extraGroups = [ "networkmanager" ];

  networking = {
    useDHCP = lib.mkDefault true;

    networkmanager = { enable = true; };
  };

  programs.nm-applet.enable = true;
}
