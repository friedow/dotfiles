{ pkgs, ... }: {
  home-manager.users.christian.home = {
    packages = with pkgs; [ yubioath-desktop ];

    file.u2f_keys = {
      source = ./u2f_keys;
      target = ".config/Yubico/u2f_keys";
    };
  };
}
