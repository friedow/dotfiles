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
        monospace = [ "FiraCode Nerd Font" ];
      };
    };

    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      source-code-pro
      lato
      fira
      fira-code
      fira-mono
    ];
  };
}
