{ inputs, ... }:
{
  perSystem =
    { pkgs-unstable, system, ... }:
    {
      packages.oh-my-pi = inputs.nixwrap.lib.${system}.mkWrap {
        name = "omp";

        # omp executes its bash tool in an embedded shell with builtin
        # coreutils, grep/rg/fd/find, sed, jq, diff and ps, fetches urls
        # and reads archives natively. Only add what it cannot do itself.
        package = pkgs-unstable.symlinkJoin {
          name = "omp";
          paths = [ pkgs-unstable.omp ];
          nativeBuildInputs = [ pkgs-unstable.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/omp --set PATH ${
              pkgs-unstable.lib.makeBinPath (
                with pkgs-unstable;
                [
                  coreutils
                  git
                  nix
                  gawk
                  python3
                ]
              )
            }
          '';
        };
        executable = "omp";

        shareCwd = true;
        capabilities.network = true;
        hostPorts = [
          8080
          1313
          4321
        ];

        mounts.writable = [ "~/.omp" ];

        environment = {
          # Sets /nix/store as a read-only substituter to pull
          # packages from.
          NIX_CONFIG = ''
            extra-substituters = local?read-only=true&trusted=true
            experimental-features = nix-command flakes
            accept-flake-config = true
          '';

          NO_COLOR = null;
          COLORTERM = null;
        };
      };
    };
}
