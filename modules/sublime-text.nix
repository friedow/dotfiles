{ pkgs, config, ... }: {
  # TODO: resolve the creation, stage and deletion problem for secrets!
  age.secrets.sublime-text-license = {
    file = ../secrets/sublime-license.age;
    path = "/home/christian/.config/sublime-text/Local/License.sublime_license";
    owner = "christian";
    group = "users";
    mode = "600";
  };

  home-manager.users.christian.home = {
    packages = with pkgs; [ sublime4 ];

    # TODO: for some reason a chown on .config/sublime-text and merge is necessary for this to work.
    # TODO: You have to call "Install Package Control" from the command palette in sublime before this works
    file.".config/sublime-text/Packages/User/Preferences.sublime-settings" = {
      text = builtins.toJSON {
        "theme" = "ayu-light.sublime-theme";
        "color_scheme" = "Packages/ayu/ayu-light.sublime-color-scheme";
        "save_on_focus_lost" = true;
        "trim_trailing_white_space_on_save" = "all";
        "shift_tab_unindent" = true;
        "tab_size" = 2;
        "translate_tabs_to_spaces" = true;
        "hot_exit" = "disabled";
      };
    };

    file.".config/sublime-text/Packages/User/Package Control.sublime-settings" = {
      text = builtins.toJSON {
        "bootstrapped" = true;
        "in_process_packages" = [];
        "installed_packages" = [
          # package control
          "Package Control"

          # theme
          "A File Icon"
          "ayu"
          "Sync Merge Scheme"

          # language server
          "LSP"
          "Nix"
          "Nushell"
          "Vue Syntax Highlight"
          "LSP-volar"
        ];
      };
    };
  };
}
