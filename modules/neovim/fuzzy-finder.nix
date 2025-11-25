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
            action = "find_files find_command=rg,--files,--hidden,--glob=!.git";
          };
          "<leader>/" = {
            action = "live_grep";
          };
        };

        settings = {
          defaults = {
            layout_strategy = "vertical";
            layout_config = {
              width = 0.5;
              prompt_position = "top";
              mirror = true;
            };
            sorting_strategy = "ascending";
          };

          pickers = {
            live_grep = {
              additional_args.__raw = ''
                function(opts)
                  return {"--hidden", "--glob=!.git"}
                end
              '';
            };
          };
        };
      };
    };
  };
}
