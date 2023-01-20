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
    ./gtk.nix
    ./hm-alias.nix
    ./nautilus.nix
    ./networking.nix
    ./nix-cli.nix
    ./pavucontrol.nix
    ./plymouth
    ./polkit.nix
    ./screensharing.nix
    # ./search.nix
    ./sway
    ./swaylock
    ./time.nix
    ./users.nix
    ./vscode.nix
    ./wdisplays.nix
    ./yubikey
    ./zsh
  ];
}
