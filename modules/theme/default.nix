{ inputs, pkgs, ... }: {
  imports = [ inputs.stylix.nixosModules.stylix ];

  fonts.fonts = with pkgs; [ (nerdfonts.override { fonts = [ "FiraCode" ]; }) ];

  stylix = {
    image = ./wallpaper.png;

    fonts = {
      serif = {
        package = pkgs.source-serif;
        name = "Source Serif";
      };

      sansSerif = {
        package = pkgs.source-sans;
        name = "Source Sans";
      };

      monospace = {
        package = pkgs.fira-code;
        name = "Fira Code";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };

    # TODO: add this in 23.11
    # cursor = {
    #   package = pkgs.nordzy-cursor-theme;
    #   name = "Nordzy-cursors";
    #   size = 32;
    # };

    targets.plymouth = {
      logo = ./logo.png;
      logoAnimated = false;
    };

    polarity = "light";

    base16Scheme = {
      base00 = "ffffff"; # base
      base01 = "f6f7f9"; # mantle

      base02 = "dcdee5"; # surface0
      base03 = "cbced8"; # surface1
      base04 = "babec9"; # surface2

      base05 = "565976"; # text

      base06 = "dc8a78"; # rosewater
      base07 = "7287fd"; # lavender
      base08 = "d20f39"; # red
      base09 = "fe640b"; # peach
      base0A = "df8e1d"; # yellow
      base0B = "40a02b"; # green
      base0C = "179299"; # teal
      base0D = "1e66f5"; # blue
      base0E = "8839ef"; # mauve
      base0F = "dd7878"; # flamingo
    };
  };
}
