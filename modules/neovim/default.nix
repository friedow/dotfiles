{ pkgs, pkgs-unstable, ... }:
let
  color = import ../../config/colors.nix;

  improvedft = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "improvedft";
    src = pkgs.fetchFromGitHub {
      owner = "chrisbra";
      repo = "improvedft";
      rev = "1f0b78b55ba5fca70db0f584d8b5e56a35fd26f6";
      hash = "sha256-Db1NkRdNNjZoKHpKErNFYI8BBfdX2wCmfohV2uAwVtA=";
    };
  };

  format-on-save-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "format-on-save-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "elentok";
      repo = "format-on-save.nvim";
      rev = "b7ea8d72391281d14ea1fa10324606c1684180da";
      hash = "sha256-y5zAZRuRIQEh6pEj/Aq5+ah2Qd+iNzbZgC5Z5tN1MXw=";
    };
  };
in {
  home-manager.users.christian = {

    home.packages = [
      # telescope dependencies
      pkgs.ripgrep
      pkgs.fd

      # lsp dependencies
      pkgs.nil
      pkgs.nodePackages.typescript-language-server
      pkgs.nodePackages.pyright
      pkgs.rust-analyzer
      pkgs.nodePackages.volar
      pkgs.marksman

      # formatter dependencies
      pkgs-unstable.prettierd
      pkgs.black
      pkgs.nixfmt
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
      '';

      plugins = with pkgs.vimPlugins; [
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

        vim-surround
        autoclose-nvim

        trouble-nvim

        catppuccin-nvim

        improvedft

        format-on-save-nvim
      ];
    };
  };
}
