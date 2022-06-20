{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;

    enableAutosuggestions = true;

    envExtra = "loc() { find . -name \"*.$1\" | xargs wc -l }";

    oh-my-zsh = {
      enable = true;
      custom = "$HOME/.config/oh-my-zsh";
      theme = "typewritten";
    };
  };

  home.file.typewritten-theme = {
    source = "/etc/nixos/home/zsh/typewritten.zsh-theme";
    target = ".config/oh-my-zsh/themes/typewritten.zsh-theme";
  };
}
