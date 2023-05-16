{ ... }: {
  users.users.christian = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
  nix.settings.trusted-users = [ "@wheel" ];
}
