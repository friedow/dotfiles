{ config, pkgs, lib, inputs, ... }: {
  # nix develop, nix shell, ... should use the package index
  # which was used to build the system. This config enforces that.

  # disable the global flake registry,
  # we build our own based on the system flakes' inputs
  environment.etc."nix/registry-empty.json".text =
    ''{ "flakes": [], "version": 2 }'';

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    extraOptions = ''
      flake-registry = /etc/nix/registry-empty.json
    '';

    package = pkgs.nixFlakes;

    registry = {
      self.flake = inputs.self;
      nixpkgs.flake = inputs.nixpkgs;
      nixpkgs-unstable.flake = inputs.nixpkgs-unstable;
    };

    # change nixpkgs variable from channel to flake
    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
      "nixpkgs-unstable=${inputs.nixpkgs-unstable}"
    ];

    # automatic garbage collection
    # gc = {
    #   automatic = true;
    #   dates = "weekly";
    #   options = "--delete-older-than 14d";
    #   persistent = true;
    # };

    # automatic store optimise
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };
}
