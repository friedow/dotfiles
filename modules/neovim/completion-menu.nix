{ ... }:
{
  home-manager.users.christian.programs.nixvim.plugins = {
    cmp-treesitter.enable = true;
    cmp-rg.enable = true;
    cmp-nvim-lsp.enable = true;
    cmp-nvim-lsp-signature-help.enable = true;

    cmp = {
      enable = true;

      settings = {
        completion = {
          completeopt = "menu,menuone,noinsert";
        };

        mapping = {
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.close()";
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = "cmp.mapping.confirm({ select = true })";
        };

        sources = [
          {
            name = "nvim_lsp_signature_help";
            group_index = 1;
          }
          {
            name = "nvim_lsp";
            group_index = 2;
          }

          {
            name = "rg";
            group_index = 3;
          }
        ];
      };
    };
  };
}
