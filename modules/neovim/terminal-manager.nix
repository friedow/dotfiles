{ pkgs, inputs, ... }: {
  home-manager.users.christian.programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "buggler-nvim";
        src = inputs.buggler-nvim;
      })
    ];

    keymaps = [
      {
        action = "<C-\\><C-n>";
        key = "<Esc>";
        mode = "t";
        options.silent = true;
      }
      {
        action.__raw = ''
          function()
            require("buggler").toggle_terminal_buffer("opencode", "opencode --auto")
          end
        '';
        key = "<leader>a";
        mode = "n";
        options.silent = true;
      }
      {
        action.__raw = ''
          function()
            require("buggler").toggle_terminal_buffer("Terminal 6")
          end
        '';
        key = "<leader>y";
        mode = "n";
        options.silent = true;
      }
      {
        action.__raw = ''
          function()
            require("buggler").toggle_terminal_buffer("Terminal 7")
          end
        '';
        key = "<leader>u";
        mode = "n";
        options.silent = true;
      }
      {
        action.__raw = ''
          function()
            require("buggler").toggle_terminal_buffer("Terminal 8")
          end
        '';
        key = "<leader>i";
        mode = "n";
        options.silent = true;
      }
      {
        action.__raw = ''
          function()
            require("buggler").toggle_terminal_buffer("Terminal 9")
          end
        '';
        key = "<leader>o";
        mode = "n";
        options.silent = true;
      }
      {
        action.__raw = ''
          function()
            require("buggler").toggle_terminal_buffer("Terminal 10")
          end
        '';
        key = "<leader>p";
        mode = "n";
        options.silent = true;
      }
    ];
  };
}
