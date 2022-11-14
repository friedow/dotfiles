{ ... }: {
  home.stateVersion = "21.11";
  imports = [
    ./alacritty.nix
    ./brave.nix
    ./element.nix
    ./flameshot.nix
    ./git.nix
    ./sway.nix
    ./swaylock
    ./vscode.nix
    ./wdisplays.nix
    ./zsh
  ];
}
