{
  home-manager.users.christian = {
    programs.zellij = {
      enable = true;
      settings = {
        simplified_ui = false;
        show_release_notes = false;
        show_startup_tips = false;
      };
      extraConfig = ''
        keybinds {
          unbind "Ctrl g"
          // keybinds are divided into modes
          normal {
            bind "Alt e" { Run "zellij" "action" "go-to-tab-name" "editor" { close_on_exit true; }; }
            bind "Alt a" { Run "zellij" "action" "go-to-tab-name" "agent" { close_on_exit true; }; }
            bind "Alt 1" { Run "zellij" "action" "go-to-tab-name" "terminal 1" { close_on_exit true; }; }
            bind "Alt 2" { Run "zellij" "action" "go-to-tab-name" "terminal 2" { close_on_exit true; }; }
            bind "Alt 3" { Run "zellij" "action" "go-to-tab-name" "terminal 3" { close_on_exit true; }; }
          }
        }
      '';
    };

    home.file.".config/zellij/layouts/main.kdl".text = ''
      layout {
        cwd "."
        tab name="editor" {
          pane {
            command "nvim"
            args "."
          }
        }
        tab name="agent" {
          pane {
            command "claude"
            start_suspended true
          }
        }
        tab name="terminal 1" {
          pane
        }
        tab name="terminal 2" {
          pane 
        }
        tab name="terminal 3" {
          pane
        }
      }
    '';
  };
}
