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

  format-on-save-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "format-on-save-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "elentok";
      repo = "format-on-save.nvim";
      rev = "b7ea8d72391281d14ea1fa10324606c1684180da";
      hash = "sha256-y5zAZRuRIQEh6pEj/Aq5+ah2Qd+iNzbZgC5Z5tN1MXw=";
    };
  };

  kitty-scrollback-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "kitty-scrollback-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "mikesmithgh";
      repo = "kitty-scrollback.nvim";
      rev = "340485737cb73476cfbd269923ab5af492faef87";
      hash = "sha256-7hfxW7Ntgi2UqefFygdEFA7LKnR88mdtaJr3OLg/tDs=";
    };
  };
}
