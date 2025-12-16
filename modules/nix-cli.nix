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
        # for container in builds support
        "auto-allocate-uids"
        "cgroups"
      ];
      auto-allocate-uids = true;

      substituters = [ "https://friedow.cachix.org/" ];
      trusted-substituters = [ "https://friedow.cachix.org/" ];
      trusted-public-keys = [ "friedow.cachix.org-1:JDEaYMqNgGu+bVPOca7Zu4Cp8QDMkvQpArKuwPKa29A=" ];

      system-features = [
        # default values
        "benchmark"
        "big-parallel"
        "kvm"
        "nixos-test"
        # added this to run clan container tests
        "uid-range"
      ];
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
    # showDerivationWarnings = [ "maintainerless" ];
  };

  _module.args.pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs) config;
    system = pkgs.stdenv.hostPlatform.system;
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
