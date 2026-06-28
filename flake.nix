{
  description = "friedow system config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    centerpiece = {
      url = "github:friedow/centerpiece";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        treefmt-nix.follows = "treefmt-nix";
      };
    };

    clan = {
      url = "git+https://git.clan.lol/clan/clan-core?ref=26.05";
      inputs = {
        treefmt-nix.follows = "treefmt-nix";
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        systems.follows = "systems";
      };
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    incline-nvim = {
      url = "github:b0o/incline.nvim";
      flake = false;
    };

    jail-nix.url = "sourcehut:~alexdavid/jail.nix";

    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        systems.follows = "systems";
      };
    };

    stylix = {
      url = "github:danth/stylix/release-26.05";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        systems.follows = "systems";
      };
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zmk-nix = {
      url = "github:lilyinstarlight/zmk-nix/5f1e3174860e84b60839be393645318a137e89db";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Dependencies for input deduplication
    systems = {
      url = "github:nix-systems/default/future-26.11";
    };
  };

  outputs =
    { ... }@inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { lib, ... }:
      {
        # access via nix repl debug.x
        # debug = true;

        imports = [
          inputs.treefmt-nix.flakeModule
          ./clan.nix
          ./modules
          ./packages
          ./templates
        ];

        systems = [ "x86_64-linux" ];

        perSystem =
          {
            pkgs,
            inputs',
            system,
            ...
          }:
          {
            _module.args.pkgs-unstable = import inputs.nixpkgs-unstable {
              inherit system;
              config = {
                allowUnfree = true;
              };
            };

            devShells.default = pkgs.mkShell {
              packages = [ inputs'.clan.packages.clan-cli ];
            };

            treefmt = {
              projectRootFile = "flake.nix";
              programs = {
                nixfmt.enable = true;
                stylua.enable = true;
              };
            };
          };
      }
    );
}
