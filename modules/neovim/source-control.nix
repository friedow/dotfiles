{ ... }:
{
  home-manager.users.christian.programs.nixvim = {
    plugins = {
      gitsigns.enable = true;
      diffview.enable = true;
    };
  };
}
