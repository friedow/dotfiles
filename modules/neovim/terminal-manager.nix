{ pkgs, ... }:
let
  buggler-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "buggler-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "friedow";
      repo = "buggler.nvim";
      rev = "31292742d9676b7ae2fa776403563f7b74fbf20d";
      hash = "sha256-XlWVLIkqmnW4hPZ8dbHDr0oPSv5ZSx6CmUmSuKHrCnM=";
    };
  };
in
{
  home-manager.users.christian.programs.nixvim = {
    extraPlugins = [
      buggler-nvim
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
            require("buggler").toggle_terminal_buffer("Terminal 6")
          end
        '';
        key = "<C-6>";
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
           	require("buggler").toggle_terminal_buffer("Terminal 7")
          end
        '';
        key = "<C-7>";
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
           	require("buggler").toggle_terminal_buffer("Terminal 8")
          end
        '';
        key = "<C-8>";
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
           	require("buggler").toggle_terminal_buffer("Terminal 9")
          end
        '';
        key = "<C-9>";
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
           	require("buggler").toggle_terminal_buffer("Terminal 10")
          end
        '';
        key = "<C-0>";
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
