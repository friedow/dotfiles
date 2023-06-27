{
  description = "friedow system config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # opengl wrapper for nvidia
    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix.url = "github:ryantm/agenix";

    arion = {
      url = "github:hercules-ci/arion";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
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
          permittedInsecurePackages = [
            "openssl-1.1.1u"
          ];
        };
      };
      desktop-modules = [
        ./modules/audio.nix
        ./modules/bootscreen
        ./modules/browser.nix
        ./modules/clipboard.nix
        ./modules/cross-compile.nix
        ./modules/display-manager.nix
        ./modules/docker.nix
        ./modules/file-manager.nix
        ./modules/fonts.nix
        ./modules/git.nix
        ./modules/gtk.nix
        ./modules/hibernate.nix
        ./modules/home-manager.nix
        ./modules/kernel.nix
        ./modules/launcher
        ./modules/lockscreen
        ./modules/networking.nix
        ./modules/notifications.nix
        ./modules/office.nix
        ./modules/shell.nix
        ./modules/nix-cli.nix
        ./modules/password-manager.nix
        ./modules/privilige-manager.nix
        ./modules/screensharing.nix
        ./modules/screenshots.nix
        ./modules/secret-management.nix
        ./modules/session.nix
        ./modules/sublime-text.nix
        ./modules/sublime-merge.nix
        ./modules/terminal.nix
        ./modules/time.nix
        ./modules/users.nix
        ./modules/vscode.nix
        ./modules/yubikey
        ./modules/window-manager
      ];

      server-system = "aarch64-linux";
      server-pkgs = (import nixpkgs) {
        system = server-system;
      };
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
          modules = desktop-modules ++ [ ./hardware-configuration/avalanche.nix ];
        };

        hurricane = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = desktop-system;
          pkgs = desktop-pkgs;
          modules = desktop-modules ++ [ ./hardware-configuration/hurricane.nix ];
        };

        landslide = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = server-system;
          pkgs = server-pkgs;
          modules = server-modules ++ [ ./hardware-configuration/landslide.nix ];
        };
      };

      devShells.x86_64-linux.default =
        with desktop-pkgs;
        stdenv.mkDerivation {
          name = "dotfiles";
          buildInputs = [ nixfmt nil ];
        };
    };
}
