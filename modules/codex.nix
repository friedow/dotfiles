{ pkgs-unstable, ... }:
{
  home-manager.users.christian.programs.codex = {
    enable = true;
    package = pkgs-unstable.codex;
  };

  home-manager.users.christian.programs.claude-code = {
    enable = true;
    package = pkgs-unstable.claude-code;
  };
}
