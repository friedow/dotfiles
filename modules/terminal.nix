{ pkgs, ... }:
let
  custom-nvim-plugins = import ./neovim/custom-plugins.nix pkgs;
in
{
  home-manager.users.christian.programs.kitty = {
    enable = true;

    shellIntegration.enableFishIntegration = true;

    settings = {
      confirm_os_window_close = 0;
      cursor_blink_interval = 0;
      cursor_shape = "beam";
      window_padding_width = 10;

      "map ctrl+c" = "copy_or_interrupt";

      # kitty scrollback
      # TODO: continue
      allow_remote_control = "socket-only";
      listen_on = "unix:/tmp/kitty";
      # kitty-scrollback.nvim Kitten alias
      "action_alias kitty_scrollback_nvim kitten" = "${custom-nvim-plugins.kitty-scrollback-nvim}/python/kitty_scrollback_nvim.py";

      # Browse scrollback buffer in nvim
      "map kitty_mod+h" = "kitty_scrollback_nvim";
      # Browse output of the last shell command in nvim
      "map kitty_mod+g" = "kitty_scrollback_nvim --config ksb_builtin_last_cmd_output";
      # Show clicked command output in nvim
      "mouse_map ctrl+shift+right" = "press ungrabbed combine : mouse_select_command_output : kitty_scrollback_nvim --config ksb_builtin_last_visited_cmd_output";
    };
  };
}
