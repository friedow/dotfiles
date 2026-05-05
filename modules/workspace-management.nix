{ pkgs, ... }:
{
  home-manager.users.christian.home.packages = [
    (import ../packages/workspace-management { inherit pkgs; })
  ];
}
