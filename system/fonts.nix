{ pkgs, ... }:
let fonts = import ../config/fonts.nix;
in {
  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;

    fontconfig = {
      enable = true;
      antialias = true;
      useEmbeddedBitmaps = true;

      defaultFonts = {
        serif = [ fonts.serif ];
        sansSerif = [ fonts.sansSerif ];
        monospace = [ fonts.monospace ];
      };
    };

    fonts = with pkgs; [
      source-code-pro
      lato
      nerdfonts
      fira
      fira-code
      fira-mono
    ];
  };
}
