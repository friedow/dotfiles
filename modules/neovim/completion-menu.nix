{ pkgs-unstable, ... }:
{

  home-manager.users.christian.programs.nixvim.extraConfigLuaPre = ''
    vim.opt.runtimepath:prepend("/home/christian/Code/friedow/blink.cmp")
    vim.opt.runtimepath:prepend("/home/christian/Code/friedow/blink-cmp-zsh")
  '';

  home-manager.users.christian.programs.nixvim.plugins = {
    blink-cmp = {
      enable = true;
      package = pkgs-unstable.vimPlugins.blink-cmp;
      settings = {
        keymap = {
          preset = "none";

          "<C-space>" = [
            "show"
            "show_documentation"
            "hide_documentation"
            "fallback"
          ];

          "<Tab>" = [
            "select_and_accept"
            "fallback"
          ];

          "<Up>" = [
            "select_prev"
            "fallback"
          ];
          "<Down>" = [
            "select_next"
            "fallback"
          ];

          "<C-Up>" = [
            "scroll_documentation_up"
            "fallback"
          ];
          "<C-Down>" = [
            "scroll_documentation_down"
            "fallback"
          ];
        };

        sources.providers = {
          zsh = {
            enabled = true;
            module = "blink-cmp-zsh";
            name = "zsh";
          };
        };

        signature.enabled = true;
        term = {
          enabled = true;
          keymap.preset = "inherit";
          sources = [ "zsh" ];
        };

        cmdline = {
          enabled = true;
          keymap.preset = "inherit";
        };
      };
    };
  };
}
