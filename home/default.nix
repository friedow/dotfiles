{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  home-config-dir = "/etc/nixos/home";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.christian = {
    home.stateVersion = "21.11";
    imports = [
      "${home-config-dir}/alacritty.nix"
      "${home-config-dir}/chromium.nix"
      "${home-config-dir}/firefox.nix"
      "${home-config-dir}/git.nix"
      "${home-config-dir}/i3.nix"
      "${home-config-dir}/rofi.nix"
      "${home-config-dir}/vscode.nix"
      "${home-config-dir}/zsh.nix"
    ];
  };
}
