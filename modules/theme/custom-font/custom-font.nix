{ stdenv, lib, fira-code, nerd-font-patcher, python3Packages, fetchzip }:
let
  nerd-font-patcher = python3Packages.buildPythonApplication rec {
    pname = "nerd-font-patcher";
    version = "3.1.1";

    src = fetchzip {
      url =
        "https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/FontPatcher.zip";
      sha256 = "sha256-H2dPUs6HVKJcjxy5xtz9nL3SSPXKQF3w30/0l7A0PeY=";
      stripRoot = false;
    };

    propagatedBuildInputs = with python3Packages; [ fontforge ];

    format = "other";

    postPatch = ''
      sed -i font-patcher \
        -e 's,__dir__ + "/src,"'$out'/share/,'
      sed -i font-patcher \
        -e  's,/bin/scripts/name_parser,/../lib/name_parser,'
    '';
    # Note: we cannot use $out for second substitution

    patches = [ ./nerd-font-patcher-custom-glyph-size.patch ];

    dontBuild = true;

    installPhase = ''
      mkdir -p $out/bin $out/share $out/lib
      install -Dm755 font-patcher $out/bin/nerd-font-patcher
      cp -ra src/glyphs $out/share/
      cp -ra bin/scripts/name_parser $out/lib/
    '';

    meta = with lib; {
      description = "Font patcher to generate Nerd font";
      homepage = "https://nerdfonts.com/";
      license = licenses.mit;
      maintainers = with maintainers; [ ck3d ];
    };
  };

in stdenv.mkDerivation {
  pname = "nerdfonts";
  version = "0.1.0";
  src = ./.;
  buildPhase = ''
    ${nerd-font-patcher}/bin/nerd-font-patcher --complete --custom /build/custom-font/custom-glyphs.svg ${fira-code}/share/fonts/truetype/FiraCode-VF.ttf
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
