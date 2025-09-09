{
  description = "friedow system config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    centerpiece = {
      url = "github:friedow/centerpiece?ref=feat/egui";
      # inputs.nixpkgs.follows = "nixpkgs"; TODO: resolve rustc mismatch
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
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
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

      desktop-modules = [
        ./modules/audio.nix
        ./modules/bootscreen.nix
        ./modules/blue-light-filter.nix
        ./modules/browser.nix
        ./modules/centerpiece.nix
        ./modules/clipboard.nix
        ./modules/cursor.nix
        ./modules/disable-services.nix
        ./modules/disko.nix
        ./modules/display-manager.nix
        ./modules/file-manager.nix
        ./modules/git.nix
        ./modules/gtk.nix
        ./modules/home-manager.nix
        ./modules/inkscape
        ./modules/lockscreen
        ./modules/neovim
        ./modules/networking.nix
        ./modules/notifications.nix
        ./modules/resource-monitor.nix
        ./modules/shell
        ./modules/nix-cli.nix
        ./modules/password-manager.nix
        ./modules/privilige-manager.nix
        ./modules/secret-management.nix
        ./modules/session.nix
        ./modules/sublime-merge.nix
        ./modules/terminal.nix
        ./modules/theme
        ./modules/time.nix
        ./modules/user-christian.nix
        ./modules/yubikey.nix
        ./modules/window-manager.nix
      ];

      personal-modules = [ ];

      work-modules = [
        ./modules/devenv.nix
        ./modules/glab.nix
        ./modules/xdg-utils.nix
      ];
    in
    (inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.treefmt-nix.flakeModule
      ];
      flake = {
        nixosConfigurations = {
          avalanche = inputs.nixpkgs.lib.nixosSystem {
            inherit specialArgs;
            modules = desktop-modules ++ personal-modules ++ [ ./hardware-configuration/avalanche.nix ];
          };

          bootstick = inputs.nixpkgs.lib.nixosSystem {
            inherit specialArgs;
            modules = desktop-modules ++ personal-modules ++ [ ./hardware-configuration/bootstick.nix ];
          };

          hurricane = inputs.nixpkgs.lib.nixosSystem {
            inherit specialArgs;
            modules = desktop-modules ++ personal-modules ++ [ ./hardware-configuration/hurricane.nix ];
          };

          tsunami = inputs.nixpkgs.lib.nixosSystem {
            inherit specialArgs;
            modules = desktop-modules ++ work-modules ++ [ ./hardware-configuration/tsunami.nix ];
          };
        };

      };
      systems = [
        # systems for which you want to build the `perSystem` attributes
        "x86_64-linux"
        # ...
      ];
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
    });
}
