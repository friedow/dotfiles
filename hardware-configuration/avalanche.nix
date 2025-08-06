{ pkgs, ... }:
{
  networking.hostName = "avalanche";
  # TODO: refresh when setting this deveice up again
  system.stateVersion = "21.11";
  home-manager.users.christian.home.stateVersion = "21.11";

  # TODO: neu & setup this device again
  # disko.devices.disk.main.device = "/dev/disk/by-id/nvme0n1";

  # old
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/66913558-e999-4e53-b977-cc5c24e38754";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

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
    powerManagement.cpuFreqGovernor = "powersave";
  };

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
