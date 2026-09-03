{ pkgs, ... }:
{
  home-manager.users.christian.programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.harpoon2 ];

    extraConfigLua = ''
      require("harpoon").setup()
    '';

    keymaps = [
      {
        action.__raw = ''
          function()
            require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
          end
        '';
        key = "<leader>hh";
        mode = "n";
        options.silent = true;
      }
      {
        action.__raw = ''
          function()
            require("harpoon"):list():add()
          end
        '';
        key = "<leader>ha";
        mode = "n";
        options.silent = true;
      }
      {
        action.__raw = ''
          function()
            require("harpoon"):list():select(1)
          end
        '';
        key = "<leader>q";
        mode = "n";
        options.silent = true;
      }
      {
        action.__raw = ''
          function()
            require("harpoon"):list():select(2)
          end
        '';
        key = "<leader>w";
        mode = "n";
        options.silent = true;
      }
      {
        action.__raw = ''
          function()
            require("harpoon"):list():select(3)
          end
        '';
        key = "<leader>e";
        mode = "n";
        options.silent = true;
      }
      {
        action.__raw = ''
          function()
            require("harpoon"):list():select(4)
          end
        '';
        key = "<leader>r";
        mode = "n";
        options.silent = true;
      }
      {
        action.__raw = ''
          function()
            require("harpoon"):list():select(5)
          end
        '';
        key = "<leader>t";
        mode = "n";
        options.silent = true;
      }
    ];
  };
}
