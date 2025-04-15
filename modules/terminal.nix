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


      function ensure_five_tabs(win)
        local mux_window = win:mux_window()
        local tabs = mux_window:tabs()
        if #tabs < 5 then
          for i=#tabs,4 do
            mux_window:spawn_tab({})
          end
        end
      end

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
            action = wezterm.action_callback(function(win, pane)
              ensure_five_tabs(win)
              win:mux_window():tabs()[1]:activate()
            end),
          },
          {
            key = '7',
            mods = 'CTRL',
            action = wezterm.action_callback(function(win, pane)
              ensure_five_tabs(win)
              win:mux_window():tabs()[2]:activate()
            end),
          },
          {
            key = '8',
            mods = 'CTRL',
            action = wezterm.action_callback(function(win, pane)
              ensure_five_tabs(win)
              win:mux_window():tabs()[3]:activate()
            end),
          },
          {
            key = '9',
            mods = 'CTRL',
            action = wezterm.action_callback(function(win, pane)
              ensure_five_tabs(win)
              win:mux_window():tabs()[4]:activate()
            end),
          },
          {
            key = '0',
            mods = 'CTRL',
            action = wezterm.action_callback(function(win, pane)
              ensure_five_tabs(win)
              win:mux_window():tabs()[5]:activate()
            end),
          },
        }
      }
    '';
  };
}
