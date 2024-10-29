{ inputs, ... }:
{
  home-manager.users.christian = {
    imports = [ inputs.centerpiece.hmModules."x86_64-linux".default ];
    programs.centerpiece = {
      enable = true;
      services.index-git-repositories.enable = true;
      config.plugin = {
        sway_windows.enable = false;
        gitmoji.enable = true;
        git_repositories.commands = [
          [
            "sublime_merge"
            "--new-window"
            "$GIT_DIRECTORY"
          ]
          [
            "kitty"
            "--directory"
            "$GIT_DIRECTORY"
            "--execute"
            "direnv"
            "exec"
            "."
            "nvim"
            "."
          ]
        ];
      };
    };
  };
}
