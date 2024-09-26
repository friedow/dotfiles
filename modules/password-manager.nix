{ pkgs, ... }:
{
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    package = pkgs._1password-gui;
    polkitPolicyOwners = [ "christian" ];
  };

  home-manager.users.christian.programs.ssh.enable = true;
  home-manager.users.christian.xdg.desktopEntries."1password" = {
    name = "1Password";
    genericName = "Password Manager";
    exec = "1password --ozone-platform-hint=auto";
    terminal = false;
  };
}
