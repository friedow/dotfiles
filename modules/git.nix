{ config, pkgs, ... }: {
  home-manager.users.christian.programs.git = {
    enable = true;
    includes = [
      { path = "~/.config/git/user"; }
    ];
    # TODO: enable git commit signing by fixing 1password package to include /opt/1Password/op-ssh-sign
    # extraConfig = {
    #   user = {
    #     signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINFZsEgxiheuXM4PFUlN7di3XiZMGLk+Bxqx0Aml8zcl";
    #   };

    #   gpg = {
    #     format = "ssh";
    #   };

    #   "gpg \"ssh\"" = {
    #     program = "/opt/1Password/op-ssh-sign";
    #   };

    #   commit = {
    #     gpgsign = true;
    #   };
    # };
  };
}
