{ ... }:
{
  networking.hostName = "avalanche";
  system.stateVersion = "25.05";
  home-manager.users.christian.home.stateVersion = "25.05";

  disko.devices.disk.main.device = "/dev/disk/by-id/nvme0n1";

  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "nvme"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];
    kernelModules = [ "kvm-intel" ];
    kernelParams = [ "button.lid_init_state=open" ];
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

  powerManagement.cpuFreqGovernor = "powersave";

  hardware = {
    bluetooth.enable = true;
    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;
  };
  services.blueman.enable = true;

  # graphics card settings
  # hardware.nvidia = {
  #   package = config.boot.kernelPackages.nvidiaPackages.stable;
  #   powerManagement.enable = false;
  #   powerManagement.finegrained = false;
  #   open = true;
  #   modesetting.enable = true;
  #   prime = {
  #     nvidiaBusId = "PCI:57:0:0";
  #     intelBusId = "PCI:0:2:0";
  #     offload.enable = true;
  #   };
  # };
  # services.xserver.videoDrivers = [ "nvidia" ];
}
