{ pkgs-unstable, ... }:
{
  home-manager.users.christian = {
    home.packages = with pkgs-unstable; [
      ripgrep
      fd
    ];

    programs.nixvim.plugins.telescope = {
      enable = true;
      extensions.fzf-native.enable = true;
      keymaps = {
        "<leader>f" = {
          action = "find_files find_command=rg,--files,--hidden,-g,!.git";
        };
        "<leader>/" = {
          action = "live_grep";
        };
      };
    };
  };
}
