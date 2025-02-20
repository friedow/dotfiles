{
  description = "friedow system config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    centerpiece = {
      url = "github:friedow/centerpiece";
      # inputs.nixpkgs.follows = "nixpkgs"; TODO: resolve rustc mismatch
    };

    dotfiles-secrets = {
      url = "git+ssh://git@github.com/friedow/dotfiles-secrets.git";
      flake = false;
    };

    stylix = {
      url = "github:danth/stylix/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    { nixpkgs, treefmt-nix, ... }@inputs:
    let
      pkgs-unstable = (import inputs.nixpkgs-unstable) {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      specialArgs = {
        inherit inputs pkgs-unstable;
      };

      desktop-system = "x86_64-linux";
      desktop-pkgs = (import nixpkgs) {
        system = desktop-system;
        config = {
          allowUnfree = true;
          permittedInsecurePackages = [ "openssl-1.1.1w" ];
        };
      };

      desktop-modules = [
        ./modules/audio.nix
        ./modules/bootscreen.nix
        ./modules/blue-light-filter.nix
        ./modules/browser.nix
        ./modules/centerpiece.nix
        ./modules/clipboard.nix
        ./modules/cursor.nix
        ./modules/display-manager.nix
        ./modules/docker.nix
        ./modules/file-manager.nix
        ./modules/git.nix
        ./modules/gtk.nix
        ./modules/home-manager.nix
        ./modules/inkscape
        ./modules/lockscreen
        ./modules/neovim
        ./modules/networking.nix
        ./modules/notifications.nix
        ./modules/office.nix
        ./modules/resource-monitor.nix
        ./modules/shell.nix
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

      personal-modules = [ ./modules/git-config-personal.nix ];

      work-modules = [
        ./modules/clamav.nix
        ./modules/dns.nix
        ./modules/gcloud.nix
        ./modules/glab.nix
        ./modules/git-config-work.nix
        ./modules/mongodb-compass.nix
        ./modules/user-bender.nix
        ./modules/vagrant.nix
        ./modules/xdg-utils.nix
      ];

      treefmtEval = treefmt-nix.lib.evalModule pkgs-unstable (pkgs: {
        projectRootFile = "flake.nix";
        programs = {
          nixfmt.enable = true;
          stylua.enable = true;
        };
      });
    in
    {
      nixosConfigurations = {
        avalanche = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = desktop-system;
          pkgs = desktop-pkgs;
          modules = desktop-modules ++ personal-modules ++ [ ./hardware-configuration/avalanche.nix ];
        };

        hurricane = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = desktop-system;
          pkgs = desktop-pkgs;
          modules = desktop-modules ++ personal-modules ++ [ ./hardware-configuration/hurricane.nix ];
        };

        tsunami = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = desktop-system;
          pkgs = desktop-pkgs;
          modules = desktop-modules ++ work-modules ++ [ ./hardware-configuration/tsunami.nix ];
        };
      };

      formatter.${desktop-system} = treefmtEval.config.build.wrapper;
    };
}
