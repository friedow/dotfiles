{ ... }: {
  home-manager.users.christian.programs.btop = {
    enable = true;

    settings = {
      color_theme = "whiteout";
      theme_background = false;
    };
  };
}
