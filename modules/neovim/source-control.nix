{ pkgs-unstable, ... }:
{
  home-manager.users.christian.programs.nixvim = {
    keymaps = [
      {
        action.__raw = ''
          function()
            require("neogit").open({ kind = 'replace' })
          end
        '';
        key = "<leader>g";
        mode = "n";
        options.silent = true;
      }
    ];

    plugins = {
      gitsigns.enable = true;
      codediff = {
        enable = true;
        settings.diff.layout = "inline";
      };
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
            snacks = true;
          };

          sections = {
            recent.folded = false;
          };
        };
      };
    };
  };
}
