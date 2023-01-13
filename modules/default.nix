{ config, pkgs, ... }: {
  imports = [
    ./1password.nix
    ./alacritty.nix
    ./audio.nix
    ./autologin.nix
    ./brave.nix
    ./displays.nix
    ./docker.nix
    ./flameshot.nix
    ./fonts.nix
    ./git.nix
    ./hm-alias.nix
    ./nautilus.nix
    ./networking.nix
    ./nix-cli.nix
    ./pavucontrol.nix
    ./plymouth
    ./polkit.nix
    ./screensharing.nix
    ./sway.nix
    ./swaylock
    ./vscode.nix
    ./wdisplays.nix
    ./yubikey
    ./yubikey-pam.nix
    ./zsh
    ./zsh.nix
  ];

  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.christian = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  environment = { variables.EDITOR = "code"; };

  # include swaylock in pam for it to verify credentials
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

  
}

