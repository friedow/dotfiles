{ ... }: {
  environment.variables.TERM = "alacritty";

  home-manager.users.christian.programs.alacritty = {
    enable = true;

    settings = {
      # General
      shell.program = "fish";

      # UI
      cursor.style = { shape = "Beam"; };

      window.padding = {
        x = 12;
        y = 10;
      };
    };
  };
}
