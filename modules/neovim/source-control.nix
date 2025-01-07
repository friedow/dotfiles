{ pkgs-unstable, ... }:
let
  # git@github.com:isakbm/gitgraph.nvim.git
  gitgraph = pkgs-unstable.vimUtils.buildVimPlugin {
    name = "gitgraph-nvim";
    src = pkgs-unstable.fetchFromGitHub {
      owner = "isakbm";
      repo = "gitgraph.nvim";
      rev = "01e466b32c346a165135dd47d42f1244eca06572";
      hash = "sha256-d55IRrOhK5tSLo2boSuMhDbkerqij5AHgNDkwtGadyI=";
    };
  };
in
{
  home-manager.users.christian.programs.nixvim = {
    keymaps = [
      {
        action.__raw = ''
          function()
            require('gitgraph').draw({}, { all = true, max_count = 5000 })
          end
        '';
        key = "<C-->";
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
          	local commit_message = vim.fn.input("Commit Message: ")
          	os.execute(string.format('git commit -m "%s"', commit_message))
          end
        '';
        key = "<leader>gc";
        mode = "n";
      }
    ];

    extraConfigLua = ''
      require("gitgraph").setup({
        symbols = {
          merge_commit = '',
          commit = '',
          merge_commit_end = '',
          commit_end = '',

          -- Advanced symbols
          GVER = '',
          GHOR = '',
          GCLD = '',
          GCRD = '╭',
          GCLU = '',
          GCRU = '',
          GLRU = '',
          GLRD = '',
          GLUD = '',
          GRUD = '',
          GFORKU = '',
          GFORKD = '',
          GRUDCD = '',
          GRUDCU = '',
          GLUDCD = '',
          GLUDCU = '',
          GLRDCL = '',
          GLRDCR = '',
          GLRUCL = '',
          GLRUCR = '',
        },
        format = {
          timestamp = '%H:%M:%S %d-%m-%Y',
          fields = { 'hash', 'timestamp', 'author', 'branch_name', 'tag' },
        },
        hooks = {
          on_select_commit = function(commit)
            print('selected commit:', commit.hash)
          end,
          on_select_range_commit = function(from, to)
            print('selected range:', from.hash, to.hash)
          end,
        },
      })
    '';

    plugins.telescope = {
      keymaps = {
        "<leader>gb" = {
          action = "git_branches";
        };
      };
    };

    extraPlugins = [
      gitgraph
    ];

    plugins = {
      gitsigns.enable = true;
    };
  };
}
