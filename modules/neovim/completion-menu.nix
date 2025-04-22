{ pkgs-unstable, ... }:
{
  home-manager.users.christian.programs.nixvim.plugins = {
    blink-cmp = {
      enable = true;
      package = pkgs-unstable.vimPlugins.blink-cmp;
      settings = {
        keymap.preset = "enter";
        signature.enabled = true;
        term = {
          enabled = true;
          keymap = {
            preset = "enter";
          };
          sources = [ "buffer" ];
        };
      };
    };
  };
}
