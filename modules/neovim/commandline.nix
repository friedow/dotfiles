{ ... }:
{
  home-manager.users.christian.programs.nixvim.plugins.noice = {
    enable = true;
    settings = {
      presets.command_palette = true;
    };
  };
}
