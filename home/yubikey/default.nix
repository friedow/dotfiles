{ config, pkgs, ... }: {
  home.packages = with pkgs; [ yubioath-desktop ];

  home.file.u2f_keys = {
    source = ./u2f_keys;
    target = ".config/Yubico/u2f_keys";
  };
}
