# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let fonts = import ../config/fonts.nix;
in {
  imports = [ ./plymouth ./networking.nix ];

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

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
      autoLogin.enable = true;
      autoLogin.user = "christian";
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [ i3lock-color ];
    };
    # videoDrivers = [ "nvidia" ];
  };
  # hardware.opengl.enable = true;
  services.xserver.libinput.enable = true;

  users.users.christian = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
  };

  environment = {
    variables.EDITOR = "code";
    systemPackages = with pkgs; [ wget ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
        serif = [ fonts.serif ];
        sansSerif = [ fonts.sansSerif ];
        monospace = [ fonts.monospace ];
      };
    };

    fonts = with pkgs; [
      source-code-pro
      lato
      nerdfonts
      fira
      fira-code
      fira-mono
    ];
  };

  virtualisation.docker = {
    enable = true;
    liveRestore = false;
  };
}

