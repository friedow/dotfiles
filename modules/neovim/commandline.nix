{ ... }:
{
  home-manager.users.christian.programs.nixvim.plugins = {
    nui.enable = true;
    notify.enable = true;
    noice = {
      enable = true;
      settings = {
        presets.command_palette = true;
        messages.view_history = "popup";
      };
    };
  };
}
