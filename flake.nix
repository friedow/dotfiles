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

  outputs = { self, nixpkgs, nixgl, ... }@inputs:
    let
      pkgs = (import nixpkgs) {
        inherit system;
        config.allowUnfree = true;
      };

      specialArgs = { inherit inputs; };

      home-manager-config.home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = specialArgs;
        users.christian.home.stateVersion = "21.11";
      };

      modules = [
        inputs.home-manager.nixosModules.home-manager
        home-manager-config
        ./modules
      ];
    in {
      nixosConfigurations = {
        avalanche = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          inherit pkgs;
          inherit specialArgs;
          modules = modules ++ [ ./hardware-configuration/avalanche.nix ];
        };

        hurricane = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          inherit pkgs;
          inherit specialArgs;
          modules = modules ++ [ ./hardware-configuration/hurricane.nix ];
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
