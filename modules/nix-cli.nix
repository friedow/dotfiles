{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      substituters = [ "https://friedow.cachix.org/" ];
      trusted-substituters = [ "https://friedow.cachix.org/" ];
      trusted-public-keys = [ "friedow.cachix.org-1:JDEaYMqNgGu+bVPOca7Zu4Cp8QDMkvQpArKuwPKa29A=" ];
    };

    registry = {
      nixpkgs.flake = inputs.nixpkgs;
      n.flake = inputs.nixpkgs;
      nu.flake = inputs.nixpkgs-unstable;
    };

    # change nixpkgs variable from channel to flake
    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
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

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [ "openssl-1.1.1w" ];
    showDerivationWarnings = [ "maintainerless" ];
  };

  _module.args.pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs) system config;
  };

  home-manager.users.christian.home.packages = with pkgs; [ nix-index ];

  # use this pattern to customize the vm or iso variants
  # uses extendModules under the hood
  # virtualisation.vmVariant = {
  #   users.users.christian = {
  #     initialHashedPassword = lib.mkForce null;
  #     password = "test";
  #   };
  # };
}
