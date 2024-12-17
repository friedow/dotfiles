{ pkgs-unstable, ... }:
{
  home-manager.users.christian.programs.nixvim = {
    extraPlugins = [ pkgs-unstable.vimPlugins.harpoon2 ];

    extraConfigLua = ''
      require("harpoon").setup()
    '';

    keymaps = [
      {
        action.__raw = ''
          function()
            require("telescope._extensions.marks")()
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
        key = "<C-1>";
        mode = [
          "n"
          "t"
          "v"
          "i"
        ];
        options.silent = true;
      }
      {
        action.__raw = ''
          function()
            require("harpoon"):list():select(2)
          end
        '';
        key = "<C-2>";
        mode = [
          "n"
          "t"
          "v"
          "i"
        ];
        options.silent = true;
      }
      {
        action.__raw = ''
          function()
            require("harpoon"):list():select(3)
          end
        '';
        key = "<C-3>";
        mode = [
          "n"
          "t"
          "v"
          "i"
        ];
        options.silent = true;
      }
      {
        action.__raw = ''
          function()
            require("harpoon"):list():select(4)
          end
        '';
        key = "<C-4>";
        mode = [
          "n"
          "t"
          "v"
          "i"
        ];
        options.silent = true;
      }
      {
        action.__raw = ''
          function()
            require("harpoon"):list():select(5)
          end
        '';
        key = "<C-5>";
        mode = [
          "n"
          "t"
          "v"
          "i"
        ];
        options.silent = true;
      }
    ];
  };
}
