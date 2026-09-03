{ ... }:
{
  home-manager.users.christian.programs.nixvim = {
    globals = {
      loaded_netrw = 1;
      loaded_netrwPlugin = 1;
    };

    keymaps = [
      {
        action = "<cmd>Neotree position=current reveal<CR>";
        key = "<leader>d";
        mode = "n";
        options.silent = true;
      }
    ];

    plugins.web-devicons.enable = true;

    plugins.neo-tree = {
      enable = true;

      settings = {
        buffers = {
          follow_current_file = {
            enabled = true;
            leave_dirs_open = true;
          };
          group_empty_dirs = true;
        };

        filesystem = {
          hijack_netrw_behavior = "open_current";
          filtered_items = {
            visible = true;
          };
        };

        event_handlers = [
          {
            event = "neo_tree_buffer_enter";
            handler.__raw = ''
              function(arg)
                vim.cmd([[
                  setlocal relativenumber
                ]])
              end,
            '';
          }
        ];
      };
    };
  };
}
