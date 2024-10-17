{ ... }:
{
  home-manager.users.christian.programs.git = {
    enable = true;
    diff-so-fancy.enable = true;
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
