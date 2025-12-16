{ ... }:
{
  home-manager.users.christian.programs = {
    delta = {
      enable = true;
      options = {
        line-numbers = true;
      };
    };

    git = {
      enable = true;
      settings = {
        user.name = "Christian Friedow";
        gpg.format = "ssh";
        push.autoSetupRemote = true;
      };
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
      signing = {
        key = "~/.ssh/id_ed25519_sk.pub";
        signByDefault = true;
      };
    };
  };
}
