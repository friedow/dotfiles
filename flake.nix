{
  description = "friedow system config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # opengl wrapper for nvidia
    nixgl.url = "github:guibou/nixGL";

    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      specialArgs = { inherit inputs; };

      desktop-system = "x86_64-linux";
      desktop-pkgs = (import nixpkgs) {
        system = desktop-system;
        config.allowUnfree = true;
      };
      desktop-modules = [
        home-manager.nixosModules.home-manager
        ./modules/audio.nix
        ./modules/bootscreen
        ./modules/browser.nix
        ./modules/clipboard.nix
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
        ./modules/file-manager.nix
        ./modules/networking.nix
        ./modules/notifications.nix
        ./modules/shell.nix
        ./modules/nix-cli.nix
        ./modules/password-manager.nix
        ./modules/privilige-manager.nix
        ./modules/screensharing.nix
        ./modules/screenshots.nix
        ./modules/session.nix
        ./modules/terminal.nix
        ./modules/time.nix
        ./modules/users.nix
        ./modules/vscode.nix
        ./modules/yubikey
        ./modules/window-manager
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
      };

      devShells.x86_64-linux.default =
        with import nixpkgs { system = "x86_64-linux"; };
        stdenv.mkDerivation {
          name = "dotfiles";
          buildInputs = [ nixfmt nil ];
        };
    };
}
