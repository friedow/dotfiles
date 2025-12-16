{ pkgs, ... }:
{
  home-manager.users.christian.programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      nvim-hlslens
    ];

    extraConfigLua = ''
      require("hlslens").setup()
    '';

    keymaps = [
      {
        action = "<Cmd>noh<CR>";
        key = "<leader>l";
        mode = "n";
        options = {
          silent = true;
          noremap = true;
        };
      }
      {
        action = "<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>";
        key = "n";
        mode = "n";
        options = {
          silent = true;
          noremap = true;
        };
      }
      {
        action = "<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>";
        key = "N";
        mode = "n";
        options = {
          silent = true;
          noremap = true;
        };
      }
      {
        action = "*<Cmd>lua require('hlslens').start()<CR>";
        key = "*";
        mode = "n";
        options = {
          silent = true;
          noremap = true;
        };
      }
      {
        action = "#<Cmd>lua require('hlslens').start()<CR>";
        key = "#";
        mode = "n";
        options = {
          silent = true;
          noremap = true;
        };
      }
      {
        action = "g*<Cmd>lua require('hlslens').start()<CR>";
        key = "g*";
        mode = "n";
        options = {
          silent = true;
          noremap = true;
        };
      }
      {
        action = "g#<Cmd>lua require('hlslens').start()<CR>";
        key = "g#";
        mode = "n";
        options = {
          silent = true;
          noremap = true;
        };
      }
    ];
  };
}
