{ ... }:
{
  home-manager.users.christian.programs.git = {
    enable = true;
    difftastic.enable = true;
    includes = [ { path = "~/.config/git/user"; } ];
    extraConfig = {
      gpg.format = "ssh";
    };
    signing = {
      key = "~/.ssh/id_ed25519_sk.pub";
      signByDefault = true;
    };
  };
}
