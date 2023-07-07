{ ... }: {
  users.users.bender = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
}
