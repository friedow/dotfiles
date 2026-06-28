{ ... }:
{
  home-manager.users.christian.programs.nixvim.plugins = {
    nui.enable = true;
    notify.enable = false;
    noice = {
      enable = true;
      settings = {
        presets.command_palette = true;
        messages.view_history = "popup";
        lsp.signature.auto_open.enabled = false;
      };
    };
  };
}
