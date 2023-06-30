{ ... }: {
  home-manager.users.christian.btop = {
    enable = true;

    settings = {
      color_theme = "whiteout";
      theme_background = false;
    };
  };
}
