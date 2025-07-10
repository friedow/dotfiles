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
    includes = [ { path = "~/.config/git/user"; } ];
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
