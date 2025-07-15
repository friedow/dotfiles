{ ... }:
{
  home-manager.users.christian.programs.nixvim = {
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
      diffview.enable = true;
      neogit = {
        enable = true;

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

          integrations = {
            diffview = true;
            telescope = true;
          };
        };
      };
    };
  };
}
