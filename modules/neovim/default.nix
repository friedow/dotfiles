{ pkgs, pkgs-unstable, inputs, ... }:
let
  color = import ../../config/colors.nix;
  custom-plugins = import ./custom-plugins.nix pkgs;
in {
  home-manager.users.christian = {

    home.packages = with pkgs; [
      # telescope dependencies
      ripgrep
      fd

      # lsp dependencies
      inputs.nixd.packages."x86_64-linux".default
      pkgs.nodePackages.pyright
      pkgs.rust-analyzer
      pkgs.nodePackages.typescript-language-server
      pkgs.nodePackages."@volar/vue-language-server"
      pkgs.marksman

      # formatter dependencies
      prettierd
      black
      nixfmt
    ];

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      extraLuaConfig = (builtins.readFile ./init.lua) + ''

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

        lspconfig.nixd.setup {
          capabilities = capabilities,
          settings = {
            nixd = {
              options = {
                home_manager = {
                  expr = '(builtins.getFlake "git+file://${
                    ./../..
                  }").homeConfigurations.christian.options',
                },
              },
            },
          },  
        }

      '';

      plugins = with pkgs.vimPlugins;
        [
          neo-tree-nvim

          telescope-nvim
          telescope-fzf-native-nvim
          nvim-web-devicons
          telescope-undo-nvim

          (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
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

          trouble-nvim

          catppuccin-nvim

          custom-plugins.improvedft

          custom-plugins.format-on-save-nvim

          custom-plugins.kitty-scrollback-nvim
        ] ++ [
          pkgs-unstable.vimPlugins.harpoon2
          pkgs-unstable.vimPlugins.actions-preview-nvim
        ];
    };
  };
}
