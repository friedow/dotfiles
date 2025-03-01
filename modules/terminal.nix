{ ... }:
{
  home-manager.users.christian.programs.wezterm = {
    enable = true;
    extraConfig = ''
      return {
        window_close_confirmation = "NeverPrompt",
        enable_tab_bar = false,
        window_padding = {
          left = "2cell",
          right = "2cell",
          top = "1cell",
          bottom = "1cell",
        },
      }
    '';
  };
}
