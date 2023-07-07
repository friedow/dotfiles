{ ... }: {
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "christian" ];
  };

  home-manager.users.christian.programs.ssh.enable = true;
}
