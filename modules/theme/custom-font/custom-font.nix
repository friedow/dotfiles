{
  stdenv,
  lib,
  fira-code,
  nerd-font-patcher,
}:
let
  custom-nerd-font-patcher = nerd-font-patcher.overrideAttrs {
    patches = [ ./nerd-font-patcher-custom-glyph-size.patch ];
  };

in
stdenv.mkDerivation {
  pname = "nerdfonts";
  version = "0.1.0";
  src = ./.;
  buildPhase = ''
    ${custom-nerd-font-patcher}/bin/nerd-font-patcher --complete --custom /build/custom-font/custom-glyphs.svg ${fira-code}/share/fonts/truetype/FiraCode-VF.ttf
  '';
  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    mv FiraCodeNerdFont-Light.ttf $out/share/fonts/truetype/FiraCode.ttf
  '';

  meta = with lib; {
    description = "Fira Code with Nerdfont Icons and custom glyphs";
    homepage = "https://nerdfonts.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ friedow ];
  };
}
