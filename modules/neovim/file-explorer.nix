{ ... }:
{
  home-manager.users.christian.programs.nixvim = {
    extraConfigLua = ''
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    '';

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
