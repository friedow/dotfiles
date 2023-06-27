{ pkgs, config, ... }:
let
  environment = { variables.EDITOR = "sublime"; };

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
  age.secrets.sublime-text-license = {
    file = ../secrets/sublime-license.age;
    path = "/home/christian/.config/sublime-text/Local/License.sublime_license";
    owner = "christian";
    group = "users";
    mode = "600";
  };

  home-manager.users.christian.home = {
    packages = with pkgs; [ sublime4 ];

    file.sublime-preferences = {
      target = ".config/sublime-text/Packages/User/Preferences.sublime-settings";
      text = builtins.toJSON preferences;
    };

    file.sublime-package-control-preferences = {
      target = ".config/sublime-text/Packages/User/Package Control.sublime-settings";
      text = builtins.toJSON package-control-preferences;
    };
  };
}
