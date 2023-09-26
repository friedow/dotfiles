{
  description = "friedow system config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # opengl wrapper for nvidia
    # TODO: this can probably be removed if "hardware.opengl.enable = true;" works on hurricane
    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pop-launcher = {
      url = "github:friedow/launcher/feat/flake-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    onagre = {
      url = "github:friedow/onagre/feat/flake-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    arion = {
      url = "github:hercules-ci/arion";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    centerpiece = {
      url = "github:friedow/centerpiece";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, ... }@inputs:
    let
      specialArgs = { inherit inputs; };

      desktop-system = "x86_64-linux";
      desktop-pkgs = (import nixpkgs) {
        system = desktop-system;
        config = {
          allowUnfree = true;
          permittedInsecurePackages = [ "openssl-1.1.1v" ];
        };
      };
      desktop-modules = [
        ./modules/audio.nix
        ./modules/bootscreen
        ./modules/blue-light-filter.nix
        ./modules/browser.nix
        ./modules/clipboard.nix
        ./modules/cross-compile.nix
        ./modules/cursor.nix
        ./modules/display-manager.nix
        ./modules/docker.nix
        ./modules/file-manager.nix
        ./modules/fonts.nix
        ./modules/git.nix
        ./modules/gtk.nix
        ./modules/home-manager.nix
        ./modules/launcher
        ./modules/lockscreen
        ./modules/networking.nix
        ./modules/notifications.nix
        ./modules/office.nix
        ./modules/resource-monitor.nix
        ./modules/shell.nix
        ./modules/nix-cli.nix
        ./modules/password-manager.nix
        ./modules/privilige-manager.nix
        ./modules/screensharing.nix
        ./modules/screenshots.nix
        ./modules/secret-management.nix
        ./modules/session.nix
        ./modules/sublime-text
        ./modules/sublime-merge.nix
        ./modules/terminal.nix
        ./modules/time.nix
        ./modules/user-christian.nix
        ./modules/vscode.nix
        ./modules/yubikey
        ./modules/window-manager
      ];

      personal-modules = [
        ./modules/git-config-personal.nix
        ./modules/password-manager-ssh.nix
        ./modules/beeper.nix
        ./modules/onagre
      ];

      work-modules = [
        ./modules/gcloud.nix
        ./modules/git-config-work.nix
        ./modules/google-chrome-dev.nix
        ./modules/user-bender.nix
        ./modules/vagrant.nix
        ./modules/xdg-utils.nix
      ];

      server-system = "aarch64-linux";
      server-pkgs = (import nixpkgs) { system = server-system; };
      server-modules = [
        ./modules/arion.nix
        ./modules/cgm.nix
        ./modules/docker.nix
        ./modules/reverse-proxy.nix
        ./modules/secret-management.nix
        ./modules/ssh-server.nix
        ./modules/time.nix
        ./modules/users.nix
      ];
    in {
      nixosConfigurations = {
        avalanche = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = desktop-system;
          pkgs = desktop-pkgs;
          modules = desktop-modules ++ personal-modules
            ++ [ ./hardware-configuration/avalanche.nix ];
        };

        hurricane = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = desktop-system;
          pkgs = desktop-pkgs;
          modules = desktop-modules ++ personal-modules
            ++ [ ./hardware-configuration/hurricane.nix ];
        };

        tsunami = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = desktop-system;
          pkgs = desktop-pkgs;
          modules = desktop-modules ++ work-modules
            ++ [ ./hardware-configuration/tsunami.nix ];
        };

        landslide = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = server-system;
          pkgs = server-pkgs;
          modules = server-modules
            ++ [ ./hardware-configuration/landslide.nix ];
        };
      };

      devShells.x86_64-linux.default = with desktop-pkgs;
        stdenv.mkDerivation {
          name = "dotfiles";
          buildInputs = [ nixfmt nil ];
        };
    };
}
