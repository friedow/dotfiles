{ pkgs-unstable, ... }:
{

  home-manager.users.christian = {
    home.packages = with pkgs-unstable; [ nil ];
  };
  home-manager.users.christian.programs.nixvim = {
    extraPlugins = with pkgs-unstable.vimPlugins; [ neodev-nvim ];

    extraConfigLuaPre = ''
      require("neodev").setup()
    '';

    plugins = {
      telescope.keymaps = {
        "gd".action = "lsp_definitions";
        "gi".action = "lsp_implementations";
      };

      schemastore = {
        json.enable = true;
        yaml.enable = true;
      };

      lsp = {
        enable = true;

        package = pkgs-unstable.vimPlugins.nvim-lspconfig;

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
          pyright.enable = true;
          rust_analyzer = {
            enable = true;
            installRustc = false;
            installCargo = false;
          };
          ts_ls = {
            enable = true;
            package = pkgs-unstable.typescript-language-server;
          };
          volar = {
            enable = true;
            tslsIntegration = true;
            package = pkgs-unstable.vue-language-server;
          };
          yamlls.enable = true;
        };
      };
    };
  };
}
