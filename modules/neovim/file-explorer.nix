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
        key = "<Leader>e";
        mode = "n";
        options.silent = true;
      }
    ];

    plugins.web-devicons.enable = true;

    plugins.neo-tree = {
      enable = true;

      buffers = {
        followCurrentFile = {
          enabled = true;
          leaveDirsOpen = true;
        };
        groupEmptyDirs = true;
      };

      filesystem = {
        hijackNetrwBehavior = "open_current";
      };

      eventHandlers = {
        neo_tree_buffer_enter = ''
          function(arg)
            -- set neo-tree bg color to white
            vim.cmd.highlight({ "NeoTreeNormal", "guibg=white" })
            vim.cmd([[
              setlocal relativenumber
            ]])
          end
        '';
      };
    };
  };
}
