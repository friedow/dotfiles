{ pkgs-unstable, ... }:
{
  home-manager.users.christian = {
    home.packages = with pkgs-unstable; [
      prettierd
      nixfmt-rfc-style
      stylua
      ruff
    ];

    programs.nixvim = {
      autoCmd = [
        {
          event = [ "BufWritePre" ];
          pattern = [ "*" ];
          callback.__raw = ''
            function(args)
              require("conform").format({ bufnr = args.buf })
            end
          '';
        }
      ];

      plugins.conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            css = [ "prettierd" ];
            html = [ "prettierd" ];
            javascript = [ "prettierd" ];
            typescript = [ "prettierd" ];
            json = [ "prettierd" ];
            markdown = [ "prettierd" ];
            scss = [ "prettierd" ];
            toml = [ "prettierd" ];
            yaml = [ "prettierd" ];
            vue = [ "prettierd" ];

            lua = [ "stylua" ];
            nix = [ "nixfmt" ];
            python = [ "ruff_format" ];

            "_" = [
              "squeeze_blanks"
              "trim_whitespace"
              "trim_newlines"
            ];
          };
          format_on_save.__raw = ''{ lsp_format = "fallback" }'';
          log_level = "warn";
          notify_on_error = false;
          notify_no_formatters = false;
        };
      };
    };
  };
}
