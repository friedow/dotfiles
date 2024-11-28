{ pkgs-unstable, ... }:
{
  home-manager.users.christian.programs.nixvim = {
    keymaps = [
      {
        action.__raw = ''
          function()
          	local commit_message = vim.fn.input("Commit Message: ")
          	os.execute(string.format('git commit -m "%s"', commit_message))
          end
        '';
        key = "<leader>gc";
        mode = "n";
        options.silent = true;
      }
      {
        action = "<cmd>Flog -format=%s%d -all -order=date -open-cmd=edit<CR>";
        key = "<leader>gg";
        mode = "n";
        options.silent = true;
      }
    ];

    globals = {
      flog_enable_extended_chars = true;
      flog_enable_dynamic_commit_hl = true;
    };

    extraPlugins = with pkgs-unstable.vimPlugins; [
      vim-flog
    ];

    plugins = {
      fugitive.enable = true;
      gitsigns.enable = true;
    };
  };
}
