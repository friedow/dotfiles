{ pkgs-unstable, ... }:
{
  home-manager.users.christian.programs.nixvim = {
    # TODO: Use the enable option for this with the next nixvim upgrade
    extraPlugins = [ pkgs-unstable.vimPlugins.codediff-nvim ];
    extraConfigLua = ''
      require("codediff").setup({
        diff = { layout = "inline" },
      })
    '';

    keymaps = [
      {
        action.__raw = ''
          function()
            require("neogit").open({ kind = 'replace' })
          end
        '';
        key = "<C-g>";
        mode = [
          "n"
          "t"
          "v"
          "i"
        ];
        options.silent = true;
      }
    ];

    plugins = {
      gitsigns.enable = true;
      neogit = {
        enable = true;
        package = pkgs-unstable.vimPlugins.neogit;

        settings = {
          commit_editor.kind = "replace";
          commit_select_view.kind = "replace";
          commit_view.kind = "replace";
          description_editor.kind = "replace";
          log_view.kind = "replace";
          merge_editor.kind = "replace";
          rebase_editor.kind = "replace";
          reflog_view.kind = "replace";
          tag_editor.kind = "replace";

          filewatcher.enable = true;
          graph_style.__raw = "'kitty'";

          diff_viewer = "codediff";

          integrations = {
            codediff = true;
            telescope = true;
          };

          sections = {
            recent.folded = false;
          };
        };
      };
    };
  };
}
