{ pkgs, ... }: {
  users.users.christian.shell = pkgs.fish;
  programs.fish.enable = true;

  home-manager.users.christian = {
    home.packages = [ pkgs.grc ];
    programs.fish = {
      enable = true;

      interactiveShellInit = ''
        set fish_greeting # Disable greeting

        function fish_prompt -d "Write out the prompt"
          printf '> '
        end

        function fish_right_prompt -d "Write out the right prompt"
          printf '%s%s%s' (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
        end
      '';

      plugins = [
        {
          name = "z";
          src = pkgs.fishPlugins.z.src;
        }
        {
          name = "grc";
          src = pkgs.fishPlugins.grc.src;
        }
      ];
    };
  };
}
