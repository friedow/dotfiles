{
  lib,
  ...
}:
{
  networking.hostName = "tsunami";
  system.stateVersion = "25.05";
  home-manager.users.christian.home.stateVersion = "25.05";

  disko.devices.disk.main.device = "/dev/disk/by-id/nvme0n1";

  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "thunderbolt"
      "nvme"
      "usb_storage"
      "sd_mod"
    ];
    kernelModules = [ "kvm-intel" ];
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = "powersave";

  hardware = {
    bluetooth.enable = true;
    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;
  };
  services.blueman.enable = true;
}
