{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    oh-my-zsh = {
      enable = true;
      custom = "$HOME/.config/oh-my-zsh";
      theme = "typewritten";
    };
    envExtra = "loc() { find . -name \"*.$1\" | xargs wc -l }";
  };

  home.file.typewritten-theme = {
    source = "/etc/nixos/home/typewritten.zsh-theme";
    target = ".config/oh-my-zsh/themes/typewritten.zsh-theme";
  };
}
