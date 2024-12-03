{ pkgs-unstable, ... }:
{
  home-manager.users.christian = {
    home.packages = with pkgs-unstable; [
      ripgrep
      fd
    ];

    programs.nixvim = {
      extraConfigLua = ''
        require('telescope').load_extension('ui-select')
      '';

      plugins.telescope = {
        enable = true;
        extensions = {
          fzf-native.enable = true;
          ui-select.enable = true;
        };

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
  };
}
