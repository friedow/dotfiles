{ ... }: {
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "christian" ];
  };
}
