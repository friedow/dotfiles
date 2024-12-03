{ pkgs, ... }:
{
  improvedft = pkgs.vimUtils.buildVimPlugin {
    name = "improvedft";
    src = pkgs.fetchFromGitHub {
      owner = "chrisbra";
      repo = "improvedft";
      rev = "1f0b78b55ba5fca70db0f584d8b5e56a35fd26f6";
      hash = "sha256-Db1NkRdNNjZoKHpKErNFYI8BBfdX2wCmfohV2uAwVtA=";
    };
  };


  buggler-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "buggler-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "friedow";
      repo = "buggler.nvim";
      rev = "31292742d9676b7ae2fa776403563f7b74fbf20d";
      hash = "sha256-XlWVLIkqmnW4hPZ8dbHDr0oPSv5ZSx6CmUmSuKHrCnM=";
    };
  };
}
