{ ... }: {
  users.users.christian = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
}
