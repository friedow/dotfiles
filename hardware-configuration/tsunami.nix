{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "nvme"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/d6a166ab-22c6-4ef8-b389-89802d976329";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-29667c9b-57b9-4fb8-8e4d-1c3624d0fcdb".device = "/dev/disk/by-uuid/29667c9b-57b9-4fb8-8e4d-1c3624d0fcdb";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/3EE9-26C1";
    fsType = "vfat";
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/4e3093e1-d702-4d79-84bc-d55074c3770d"; } ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-a43f5aa4-dec1-4cf7-adbf-378175e8fe97".device = "/dev/disk/by-uuid/a43f5aa4-dec1-4cf7-adbf-378175e8fe97";
  boot.initrd.luks.devices."luks-a43f5aa4-dec1-4cf7-adbf-378175e8fe97".keyFile = "/crypto_keyfile.bin";

  networking.hostName = "tsunami";
  system.stateVersion = "23.05";
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
}
