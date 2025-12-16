{
  description = "friedow system config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    centerpiece = {
      url = "github:friedow/centerpiece?ref=feat/egui";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        treefmt-nix.follows = "treefmt-nix";
      };
    };

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dotfiles-secrets = {
      url = "git+ssh://git@github.com/friedow/dotfiles-secrets.git";
      flake = false;
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
      let
        moduleDirectoryList = builtins.attrNames (builtins.readDir ./modules);
        allModules = builtins.listToAttrs (
          builtins.map (entry: {
            name = lib.strings.removeSuffix ".nix" entry;
            value = ./. + "/modules/${entry}";
          }) moduleDirectoryList
        );
      in
      {
        # access via nix repl debug.x
        debug = true;

        imports = [
          inputs.treefmt-nix.flakeModule
        ];

        flake = {
          modules.nixos = allModules // {
            desktop-modules.imports = with inputs.self.modules.nixos; [
              blue-light-filter
              bootscreen
              browser
              centerpiece
              clipboard
              cursor
              disable-services
              disko
              display-manager
              file-manager
              git
              gtk
              home-manager
              inkscape
              lockscreen
              neovim
              networking
              nix-cli
              notifications
              password-manager
              privilige-manager
              resource-monitor
              secret-management
              session
              shell
              sublime-merge
              terminal
              theme
              time
              user-christian
              window-manager
              yubikey
            ];

            personal-modules.imports = [ ];

            work-modules.imports = with inputs.self.modules.nixos; [
              devenv
              glab
              xdg-utils
            ];
          };

          nixosConfigurations = {
            avalanche = inputs.nixpkgs.lib.nixosSystem {
              inherit specialArgs;
              modules = [
                inputs.self.modules.nixos.desktop-modules
                inputs.self.modules.nixos.personal-modules
              ] ++ [ ./hardware-configuration/avalanche.nix ];
            };

            hurricane = inputs.nixpkgs.lib.nixosSystem {
              inherit specialArgs;
              modules = [
                inputs.self.modules.nixos.desktop-modules
                inputs.self.modules.nixos.personal-modules
              ] ++ [ ./hardware-configuration/hurricane.nix ];
            };

            tsunami = inputs.nixpkgs.lib.nixosSystem {
              inherit specialArgs;
              modules = [
                inputs.self.modules.nixos.desktop-modules
                inputs.self.modules.nixos.work-modules
              ] ++ [ ./hardware-configuration/tsunami.nix ];
            };
          };
        };

        systems = [ "x86_64-linux" ];

        perSystem =
          { config, pkgs, ... }:
          {
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
