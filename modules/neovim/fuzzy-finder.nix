{ pkgs, ... }:
{
  home-manager.users.christian = {
    home.packages = with pkgs; [
      ripgrep
      fd
    ];

    programs.nixvim = {
      plugins.snacks.settings.picker = {
        enabled = true;
        layout.preset = "vertical";
      };

      keymaps = [
        {
          action.__raw = ''
            function()
              Snacks.picker.files({ hidden = true })
            end
          '';
          key = "<leader>f";
          mode = "n";
          options.silent = true;
        }
        {
          action.__raw = ''
            function()
              Snacks.picker.grep({ hidden = true })
            end
          '';
          key = "<leader>/";
          mode = "n";
          options.silent = true;
        }
      ];
    };
  };
}
