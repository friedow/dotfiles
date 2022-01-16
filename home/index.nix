{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.christian = {
    home.stateVersion = "21.11";
    imports = [
      "/etc/nixos/home/alacritty.nix"
      "/etc/nixos/home/git.nix"
      "/etc/nixos/home/i3.nix"
      "/etc/nixos/home/vscode.nix"
      "/etc/nixos/home/zsh.nix"
    ];
  };
}
