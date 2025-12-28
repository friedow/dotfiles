{
  description = "friedow system config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    centerpiece = {
      url = "github:friedow/centerpiece?ref=feat/egui";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        treefmt-nix.follows = "treefmt-nix";
      };
    };

    clan = {
      url = "git+https://git.clan.lol/clan/clan-core?shallow=1";
      inputs = {
        treefmt-nix.follows = "treefmt-nix";
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        nuschtosSearch.follows = "";
      };
    };

    stylix = {
      url = "github:danth/stylix/release-25.11";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { ... }@inputs:
    let
      specialArgs = {
        inherit inputs;
      };
    in
    (inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { lib, ... }:
      {
        # access via nix repl debug.x
        debug = true;

        imports = [
          inputs.treefmt-nix.flakeModule
          ./clan.nix
          ./modules
        ];

        flake = {
          nixosConfigurations = {
            # avalanche = inputs.nixpkgs.lib.nixosSystem {
            #   inherit specialArgs;
            #   modules = [
            #     inputs.self.modules.nixos.desktop-modules
            #     inputs.self.modules.nixos.personal-modules
            #   ]
            #   ++ [ ./hardware-configuration/avalanche.nix ];
            # };

            hurricane = inputs.nixpkgs.lib.nixosSystem {
              inherit specialArgs;
              modules = [
                inputs.self.modules.nixos.desktop-modules
                inputs.self.modules.nixos.personal-modules
              ]
              ++ [ ./hardware-configuration/hurricane.nix ];
            };

            tsunami = inputs.nixpkgs.lib.nixosSystem {
              inherit specialArgs;
              modules = [
                inputs.self.modules.nixos.desktop-modules
                inputs.self.modules.nixos.work-modules
              ]
              ++ [ ./hardware-configuration/tsunami.nix ];
            };
          };
        };

        systems = [ "x86_64-linux" ];

        perSystem =
          {
            config,
            pkgs,
            inputs',
            ...
          }:
          {
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
    ));
}
