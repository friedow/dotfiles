{ pkgs, ... }:
{
  home-manager.users.christian.programs.nixvim = {
    plugins = {
      telescope.keymaps = {
        "gd".action = "lsp_definitions";
        "gi".action = "lsp_implementations";
        "gr".action = "lsp_references";
      };

      schemastore = {
        json.enable = true;
        yaml.enable = true;
      };

      lsp = {
        enable = true;

        package = pkgs.vimPlugins.nvim-lspconfig;

        keymaps = {
          diagnostic."<leader><tab>" = "open_float";
          lspBuf = {
            "<tab>" = "hover";
            "<leader>rn" = "rename";
            "<leader>ca" = "code_action";
          };
        };

        servers = {
          eslint.enable = true;
          jsonls.enable = true;
          lua_ls = {
            enable = true;
            settings = {
              diagnostics.globals = [ "vim" ];
              workspace = {
                library = [
                  {
                    __raw = ''vim.fn.expand "$VIMRUNTIME"'';
                  }
                  {
                    __raw = ''vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"'';
                  }
                  "\${3rd}/luv/library"
                ];
              };
            };
          };
          marksman.enable = true;
          nil_ls.enable = true;
          bashls.enable = true;
          pylsp = {
            enable = true;
            settings.plugins = {
              pylsp_mypy.enabled = true;
              ruff.enabled = true;
              black.enabled = true;
            };
          };
          rust_analyzer = {
            enable = true;
            installRustc = false;
            installCargo = false;
          };
          ts_ls = {
            enable = true;
          };
          vue_ls = {
            enable = true;
            tslsIntegration = true;
          };
          yamlls.enable = true;
        };
      };
    };
  };
}
