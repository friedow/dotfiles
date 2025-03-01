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
          "<C-k>" = "cmp.mapping.scroll_docs(4)";
          "<C-j>" = "cmp.mapping.scroll_docs(-4)";
          "<Tab>" = "cmp.mapping.confirm({ select = true })";
          "<Up>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<Down>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
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
