{ pkgs-unstable, ... }:
{
  home-manager.users.christian.programs.wezterm = {
    enable = true;
    package = pkgs-unstable.wezterm;
    extraConfig = ''
      wezterm.on('gui-startup', function()
        local _, first_pane, window = wezterm.mux.spawn_window {}
        local _, second_pane, _ = window:spawn_tab {}
        local _, third_pane, _ = window:spawn_tab {}
        local _, fourth_pane, _ = window:spawn_tab {}
        local _, fifth_pane, _ = window:spawn_tab {}

        -- third_pane:send_text "top\n"
        -- '\n' this will execute you shell command
      end)

      return {
        window_close_confirmation = "NeverPrompt",
        enable_tab_bar = false,
        window_padding = {
          left = "2cell",
          right = "2cell",
          top = "1cell",
          bottom = "1cell",
        },
        keys = {
          {
            key = '6',
            mods = 'CTRL',
            action = wezterm.action.ActivateTab(0),
          },
          {
            key = '7',
            mods = 'CTRL',
            action = wezterm.action.ActivateTab(1),
          },
          {
            key = '8',
            mods = 'CTRL',
            action = wezterm.action.ActivateTab(2),
          },
          {
            key = '9',
            mods = 'CTRL',
            action = wezterm.action.ActivateTab(3),
          },
          {
            key = '0',
            mods = 'CTRL',
            action = wezterm.action.ActivateTab(4),
          },
        }
      }
    '';
  };
}
