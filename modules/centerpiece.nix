{ inputs, ... }: {
  home-manager.users.christian.home.packages =
    [ inputs.centerpiece.pkgs.default ];
}
