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
            local file_paths = {}
            for _, item in ipairs(require("harpoon"):list().items) do
                table.insert(file_paths, item.value)
            end

            local conf = require("telescope.config").values
            require("telescope.pickers").new({}, {
                prompt_title = "Harpoon",
                finder = require("telescope.finders").new_table({
                    results = file_paths,
                }),
                previewer = conf.file_previewer({}),
                sorter = conf.generic_sorter({}),
            }):find()
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
