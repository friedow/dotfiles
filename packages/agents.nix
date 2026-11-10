{ inputs, ... }:
{
  perSystem =
    { pkgs-unstable, ... }:
    let
      jail = inputs.jail-nix.lib.init pkgs-unstable;
    in
    {
      packages.oh-my-pi = jail "omp" pkgs-unstable.omp (
        with jail.combinators;
        [
          network
          mount-cwd
          no-new-session

          # Provides access to /nix/var/db and other metadata to access
          # the nix store.
          (try-readonly (noescape "/nix/var/nix"))
          (try-readonly (noescape "/nix/store"))

          # Sets /nix/store as a read-only substituter to pull
          # packages from.
          (set-env "NIX_CONFIG" ''
            extra-substituters = local?read-only=true&trusted=true
            experimental-features = nix-command flakes
            accept-flake-config = true
          '')

          (try-fwd-env "NO_COLOR")
          (try-fwd-env "TERM")
          (try-fwd-env "COLORTERM")

          (add-runtime ''
            mkdir -p "$HOME/.omp"
          '')
          (try-readwrite (noescape "~/.omp"))

          # omp executes its bash tool in an embedded shell with builtin
          # coreutils, grep/rg/fd/find, sed, jq, diff and ps, fetches urls
          # and reads archives natively. Only add what it cannot do itself.
          (add-pkg-deps (
            with pkgs-unstable;
            [
              git
              nix
              gawk
              python3
            ]
          ))
        ]
      );
    };
}
