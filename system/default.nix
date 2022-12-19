{ config, pkgs, ... }: {
  imports = [
    ./audio.nix
    ./docker.nix
    ./fonts.nix
    ./networking.nix
    ./plymouth
    ./xserver.nix
    ./zsh.nix
  ];

  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.christian = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  environment = { variables.EDITOR = "code"; };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

