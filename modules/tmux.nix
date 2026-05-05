{ ... }:
{
  home-manager.users.christian.programs.tmux = {
    enable = true;
    mouse = true;
    keyMode = "vi";
    terminal = "screen-256color";
    extraConfig = ''
      set -g status-right "%H:%M"
      set -g automatic-rename off
      set -g base-index 1
      setw -g pane-base-index 1
    '';
  };
}
