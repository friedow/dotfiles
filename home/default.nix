{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  home-config-dir = "/etc/nixos/home";
in
{
  imports = [
    (import "${home-manager}/nixos")
    ./firefox/root-config.nix
  ];

  home-manager.users.christian = {
    home.stateVersion = "22.05";
    imports = [
      "${home-config-dir}/alacritty.nix"
      "${home-config-dir}/chromium.nix"
      "${home-config-dir}/element.nix"
      "${home-config-dir}/firefox"
      "${home-config-dir}/flameshot.nix"
      "${home-config-dir}/git.nix"
      "${home-config-dir}/i3.nix"
      "${home-config-dir}/i3lock"
      "${home-config-dir}/nur.nix"
      "${home-config-dir}/vscode.nix"
      "${home-config-dir}/xfce"
      "${home-config-dir}/zsh"
    ];
  };
}
