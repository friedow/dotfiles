{ pkgs, inputs, ... }:
let
  cosmic-settings = pkgs.cosmic-settings.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      sed -i '/^OnlyShowIn=COSMIC$/d' \
        "$out/share/applications/com.system76.CosmicSettings.desktop"
    '';
  });
in
{
  home-manager.users.christian = {
    home.packages = [ cosmic-settings ];

    imports = [ inputs.centerpiece.hmModules."x86_64-linux".default ];
    programs.centerpiece = {
      enable = true;
      services.index-git-repositories.enable = true;
      config.plugin = {
        sway_windows.enable = false;
        gitmoji.enable = true;
        git_repositories.commands = [
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
