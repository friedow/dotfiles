{
  flake.modules.nixos.password-manager =
    { pkgs-unstable, ... }:
    {
      programs._1password.enable = true;
      programs._1password-gui = {
        enable = true;
        package = pkgs-unstable._1password-gui;
        polkitPolicyOwners = [ "christian" ];
      };
      environment.etc."1password/custom_allowed_browsers" = {
        text = ''
          .zen-twilight-wrapped
          zen
          zen-bin
        '';
        mode = "0755";
      };

      # TODO: move somewhere else probably git config
      home-manager.users.christian.programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
      };
      home-manager.users.christian.xdg.desktopEntries."1password" = {
        name = "1Password";
        genericName = "Password Manager";
        exec = "1password --ozone-platform-hint=auto";
        terminal = false;
      };
    };
}
