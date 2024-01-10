{ inputs, ... }: {
  home-manager.users.christian = {
    imports = [ inputs.centerpiece.hmModules."x86_64-linux".default ];
    programs.centerpiece = {
      enable = true;
      services.index-git-repositories.enable = true;
    };
  };
}
