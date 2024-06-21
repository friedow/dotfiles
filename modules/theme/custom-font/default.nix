let pkgs = import <nixpkgs> { };
in { custom-font = pkgs.callPackage ./custom-font.nix { }; }
