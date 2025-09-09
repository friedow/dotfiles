{ ... }:
{
  home-manager.users.christian.programs.git = {
    enable = true;
    delta = {
      enable = true;
      options = {
        line-numbers = true;
      };
    };
    userName = "Christian Friedow";
    includes = [
      {
        condition = "hasconfig:remote.*.url:git@github.com:*/**";
        contents = {
          user = {
            email = "christian@friedow.com";
          };
        };
      }
      {
        condition = "hasconfig:remote.*.url:gitea@git.clan.lol:*/**";
        contents = {
          user = {
            email = "christian@friedow.com";
          };
        };
      }
      {
        condition = "hasconfig:remote.*.url:git@gitlab.com:*/**";
        contents = {
          user = {
            email = "christian.friedow@apm.de";
          };
        };
      }
    ];
    extraConfig = {
      gpg.format = "ssh";
      push.autoSetupRemote = true;
    };
    signing = {
      key = "~/.ssh/id_ed25519_sk.pub";
      signByDefault = true;
    };
  };
}
