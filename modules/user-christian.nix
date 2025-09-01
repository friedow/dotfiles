{ ... }:
{
  users.users.christian = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialHashedPassword = "$y$j9T$jxFtoPcujt8cWL6iktgZa/$nWFuloO3gkhkEUXVMMY3c9KjxR8zRKt5o4LbTGX7.z1";
  };
  nix.settings.trusted-users = [ "@wheel" ];
}
