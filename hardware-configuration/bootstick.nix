{ ... }:
{
  networking.hostName = "bootstick";
  system.stateVersion = "25.05";
  home-manager.users.christian.home.stateVersion = "25.05";

  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "nvme"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];
    kernelModules = [ "kvm-intel" ];
    loader.systemd-boot.enable = true;
  };

  powerManagement.cpuFreqGovernor = "powersave";
  hardware.enableRedistributableFirmware = true;
}
