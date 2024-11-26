{ pkgs-unstable, ... }:
let
  custom-plugins = import ./custom-plugins.nix pkgs-unstable;
in
{
  home-manager.users.christian.programs.nixvim = {
    extraPlugins = [
      custom-plugins.buggler-nvim
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
