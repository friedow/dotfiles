# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./home
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "avalanche"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlo1.useDHCP = true;
  # networking.networkmanager.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
    };

    displayManager = {
      defaultSession = "xfce+i3";
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        i3lock
      ];
    };
  };
  services.xserver.libinput.enable = true;

  users.users.christian = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  environment = {
    variables.EDITOR = "code";
    systemPackages = with pkgs; [
      gitkraken
      wget
    ];
  };

  nixpkgs.config.allowUnfree = true;

  sound.enable = true;
  hardware = {
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };
  };

  fonts = {
  fontDir.enable = true;
    enableGhostscriptFonts = true;

    fontconfig = {
      enable = true;
      antialias = true;
      useEmbeddedBitmaps = true;

      defaultFonts = {
        serif = [ "Source Serif Pro" "DejaVu Serif" ];
        sansSerif = [ "Source Sans Pro" "DejaVu Sans" ];
        monospace = [ "Fira Code" "Hasklig" ];
      };
    };

    fonts = with pkgs; [
      hasklig
      source-code-pro
      overpass
      nerdfonts
      fira
      fira-code
      fira-mono
    ];
  };

  environment.etc = {
    "firefox/policies/policies.json".source = "/etc/nixos/policies.json";
  };

  system.stateVersion = "21.11";
}

