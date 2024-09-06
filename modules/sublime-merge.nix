{ pkgs, inputs, ... }:
{
  age.secrets.sublime-merge-license = {
    file = "${inputs.dotfiles-secrets}/sublime-license.age";
    path = "/home/christian/.config/sublime-merge/Local/License.sublime_license";
    owner = "christian";
    group = "users";
    mode = "600";
  };

  home-manager.users.christian.home = {
    packages = with pkgs; [ sublime-merge ];

    file.".config/sublime-merge/Packages/Meetio Theme".source = pkgs.fetchFromGitHub {
      owner = "meetio-theme";
      repo = "merge-meetio-theme";
      rev = "3c732210d1d14fee0b094beeec062efd16e24c22";
      sha256 = "sha256-EQU4/ZkiHKYJVXPcHmUYqOXchchv3NBpJGkIzDSpUww=";
    };

    file.".config/sublime-merge/Packages/User/Preferences.sublime-settings" = {
      text = builtins.toJSON {
        "always_show_command_status" = false;
        "diff_style" = "inline";
        "expand_merge_commits_by_default" = true;
        "hardware_acceleration" = "opengl";
        "hide_menu" = true;
        "ignore_diff_white_space" = false;
        "image_diff_style" = "side-by-side";
        "render_commit_dialog_message_at_top" = false;
        "side_bar_layout" = "tabs";
        "time_format" = "system";
        "translate_tabs_to_spaces" = true;
        "trim_trailing_white_space_on_save" = true;
        "theme" = "Merge Lighter.sublime-theme";
        "color_scheme" = "Meetio Lighter.sublime-color-scheme";
        "log_commands" = true;
      };
    };

    file.".config/sublime-merge/Packages/User/Default (Linux).sublime-keymap" = {
      text = builtins.toJSON [
        {
          "keys" = [ "ctrl+k" ];
          "command" = "show_command_palette";
          "args" = {
            "command" = "navigate_to_commit";
          };
        }
        {
          "keys" = [ "ctrl+shift+k" ];
          "command" = "show_command_palette";
        }
      ];
    };
  };
}
