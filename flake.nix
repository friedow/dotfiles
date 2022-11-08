{
  description = "friedow system config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    # nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixos-hardware.url = "github:NixOS/nixos-hardware";

    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";

      pkgs = (import nixpkgs) {
        inherit system;
        config.allowUnfree = true;
      };

      specialArgs = { inherit inputs; };

      home-manager-config.home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = specialArgs;
        users.christian = import ./home;
      };

      modules = [
        inputs.home-manager.nixosModules.home-manager
        home-manager-config
        ./system
      ];
    in {
      nixosConfigurations = {
        avalanche = nixpkgs.lib.nixosSystem {
          inherit system;
          inherit pkgs;
          inherit specialArgs;
          modules = modules ++ [ ./hardware-configuration/avalanche.nix ];
        };

        hurricane = nixpkgs.lib.nixosSystem {
          inherit system;
          inherit pkgs;
          inherit specialArgs;
          modules = modules ++ [ ./hardware-configuration/hurricane.nix ];
        };
      };

      devShells.x86_64-linux.default =
        with import nixpkgs { system = "x86_64-linux"; };
        stdenv.mkDerivation {
          name = "dotfiles";
          buildInputs = [ nixfmt ];
        };
    };
}

