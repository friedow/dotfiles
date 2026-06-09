{ inputs, pkgs, ... }:
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  fonts.fontconfig.localConf = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
      <!-- DejaVu Sans outscores Noto Color Emoji for emoji codepoints in fontconfig's sort; reject it entirely (runtime, no cache dependency). -->
      <selectfont>
        <rejectfont>
          <pattern>
            <patelt name="family"><string>DejaVu Sans</string></patelt>
          </pattern>
        </rejectfont>
      </selectfont>
      <!-- Strip Misc Symbols (U+2600–U+27BF) from text fonts so per-glyph fallback reaches Noto Color Emoji. -->
      <match target="scan">
        <test name="family" compare="not_eq">
          <string>Noto Color Emoji</string>
        </test>
        <edit name="charset" mode="assign">
          <minus>
            <name>charset</name>
            <charset>
              <range><int>0x2600</int><int>0x27BF</int></range>
            </charset>
          </minus>
        </edit>
      </match>
    </fontconfig>
  '';

  stylix = {
    enable = true;

    image = ./wallpaper.png;

    fonts = {
      serif = {
        package = pkgs.source-serif;
        name = "Source Serif 4";
      };

      sansSerif = {
        package = pkgs.source-sans;
        name = "Source Sans 3";
      };

      monospace = {
        package = pkgs.fira-code;
        name = "Fira Code";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };

    cursor = {
      package = pkgs.nordzy-cursor-theme;
      name = "Nordzy-cursors";
      size = 32;
    };

    # TODO: fix plymouth logo
    targets.plymouth.enable = false;

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
