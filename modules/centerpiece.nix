{ inputs, ... }: {
  home-manager.users.christian = {
    imports = [ inputs.centerpiece.hmModules."x86_64-linux".default ];
    programs.centerpiece = {
      enable = true;
      services.index-git-repositories.enable = true;
      config.plugin = {
        windows.enable = false;
        git_repositories.commands = [
          [ "kitty" "$GIT_DIRECTORY" ]
          [ "sublime_merge" "--new-window" "$GIT_DIRECTORY" ]
          [ "kitty" "--execute" "nvim" "$GIT_DIRECTORY" ]
        ];
      };
    };
  };
}
