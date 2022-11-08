{ pkgs, lib, ... }: {
  networking = {
    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    useDHCP = lib.mkDefault true;

    hosts = { "127.0.0.1" = [ "dotbase.local" ]; };

    networkmanager = {
      enable = true;
      plugins = [ pkgs.networkmanager-openvpn ];
    };
  };

  programs.nm-applet.enable = true;
}
