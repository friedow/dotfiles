{ pkgs, ... }:
{
  home-manager.users.christian.programs.nixvim.plugins.treesitter = {
    enable = true;

    settings = {
      highlight.enable = true;
      indent.enable = true;
      parser_install_dir = null;
    };
  };
}
