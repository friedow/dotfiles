{
  pkgs,
  pkgs-unstable,
  ...
}:
let
  color = import ../../config/colors.nix;
  custom-plugins = import ./custom-plugins.nix pkgs;
in
{
  home-manager.users.christian = {

    home.packages = with pkgs-unstable; [
      # telescope dependencies
      ripgrep
      fd

      # lsp dependencies
      nil
      pyright
      rust-analyzer
      nodePackages.typescript-language-server
      vue-language-server
      vscode-langservers-extracted
      marksman
      lua-language-server
      yaml-language-server

      # formatter dependencies
      prettierd
      black
      nixfmt-rfc-style
      stylua
    ];

    programs.neovim = {
      enable = true;
      package = pkgs-unstable.neovim-unwrapped;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      extraLuaConfig =
        (builtins.readFile ./init.lua)
        + ''

            require("catppuccin").setup {
              color_overrides = {
                latte = {
                  rosewater = "${color.rosewater}",
                  flamingo = "${color.flamingo}",
                  pink = "${color.pink}",
                  mauve = "${color.mauve}",
                  red = "${color.red}",
                  maroon = "${color.maroon}",
                  peach = "${color.peach}",
                  yellow = "${color.yellow}",
                  green = "${color.green}",
                  teal = "${color.teal}",
                  sky = "${color.sky}",
                  sapphire = "${color.sapphire}",
                  blue = "${color.blue}",
                  lavender = "${color.lavender}",

                  text = "${color.text}",
                  subtext1 = "${color.subtext1}",
                  subtext0 = "${color.subtext0}",

                  overlay2 = "${color.overlay2}",
                  overlay1 = "${color.overlay1}",
                  overlay0 = "${color.overlay0}",

                  surface2 = "${color.surface2}",
                  surface1 = "${color.surface1}",
                  surface0 = "${color.surface0}",

                  crust = "${color.crust}",
                  mantle = "${color.mantle}",
                  base = "${color.base}",
                },
              }
            }
          vim.cmd.colorscheme("catppuccin-latte")

          lspconfig.ts_ls.setup {
            capabilities = capabilities,
            init_options = {
              plugins = {
                {
                  name = '@vue/typescript-plugin',
                  location = '${pkgs-unstable.vue-language-server}/lib/node_modules/@vue/language-server',
                  languages = { 'vue' },
                },
              },
            },
            filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
          }

          lspconfig.volar.setup {
            capabilities = capabilities,
          }
        '';

      plugins = with pkgs-unstable.vimPlugins; [
        neo-tree-nvim

        telescope-nvim
        telescope-fzf-native-nvim
        nvim-web-devicons

        (nvim-treesitter.withPlugins (p: [
          p.nix
          p.typescript
          p.rust
          p.javascript
          p.python
          p.markdown
          p.html
          p.vue
          p.css
          p.scss
          p.yaml
          p.toml
          p.json
        ]))

        nvim-lspconfig
        SchemaStore-nvim

        # cmp
        nvim-cmp
        cmp-treesitter
        cmp-rg
        cmp-nvim-lsp
        luasnip
        cmp_luasnip
        friendly-snippets
        cmp-nvim-lsp-signature-help

        vim-surround
        autoclose-nvim

        catppuccin-nvim

        custom-plugins.improvedft

        custom-plugins.format-on-save-nvim

        custom-plugins.incline-nvim

        harpoon2

        actions-preview-nvim

        gitsigns-nvim

        nvim-hlslens
        vim-fugitive
        vim-flog

        vim-startuptime
      ];
    };
  };
}
