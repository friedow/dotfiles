{ pkgs, ... }:
let
  preferences = {
    "theme" = "ayu-light.sublime-theme";
    "color_scheme" = "Packages/ayu/ayu-light.sublime-color-scheme";
    "save_on_focus_lost" = true;
    "trim_trailing_white_space_on_save" = "all";
    "shift_tab_unindent" = true;
    "tab_size" = 2;
    "translate_tabs_to_spaces" = true;
    "hot_exit" = "disabled";
  };

  package-control-preferences = {
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
    ];
  };

in {
  home-manager.users.christian.home = {
    file.sublime-preferences = {
      target = ".config/sublime-text/Packages/User/Preferences.sublime-settings";
      text = builtins.toJSON preferences;
    };

    file.sublime-package-control-preferences = {
      target = ".config/sublime-text/Packages/User/Package Control.sublime-settings";
      text = builtins.toJSON package-control-preferences;
    };

    packages = with pkgs; [ sublime4 ];
  };
}
