{ ... }: {
  home.stateVersion = "21.11";
  imports = [
    ./alacritty.nix
    ./brave.nix
    ./element.nix
    ./flameshot.nix
    ./git.nix
    ./i3.nix
    ./i3lock
    ./picom.nix
    ./vscode.nix
    ./xfce
    ./zsh
  ];
}
