{ config, pkgs, ... }:
let
  colors = import ../../config/colors.nix;
  fonts = import ../../config/fonts.nix;

  transparent = "#00000000";

  friedow-plymouth = pkgs.stdenv.mkDerivation rec {
    pname = "friedow-plymouth";
    version = "0.0.1";

    src = ./theme;

    configurePhase = ''
      mkdir -p $out/share/plymouth/themes/
    '';

    buildPhase = "";

    installPhase = ''
      cp -r . $out/share/plymouth/themes/friedow
      cat friedow.plymouth | sed  "s@\/usr\/@$out\/@" > $out/share/plymouth/themes/friedow/friedow.plymouth
    '';
  };
in {
  boot.initrd.systemd.enable = true;
  boot.consoleLogLevel = 0;
  boot.kernelParams = ["quiet"];
  boot.plymouth = {
    enable = true;
    themePackages = with pkgs; [ friedow-plymouth ];
    theme = "friedow";
  };
}
