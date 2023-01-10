{ ... }: {
  home.stateVersion = "21.11";
  imports = [
    # ./alacritty.nix
    # ./brave.nix
    ./displays.nix
    ./flameshot.nix
    ./git.nix
    ./nautilus.nix
    ./pavucontrol.nix
    ./search.nix
    ./sway.nix
    ./swaylock
    ./vscode.nix
    ./wdisplays.nix
    ./yubikey
    ./zsh
  ];
}
