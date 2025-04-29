{ ... }:
{
  home-manager.users.christian.programs.nixvim.plugins = {
    nui.enable = false;
    notify.enable = false;
    noice = {
      enable = false;
      settings = {
        presets.command_palette = true;
        messages.view_history = "popup";
        # notify.view = "mini";
        lsp.signature.auto_open.enabled = false;
      };
    };
  };
}
