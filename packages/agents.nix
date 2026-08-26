{ inputs, ... }:
{
  perSystem =
    { pkgs-unstable, self', ... }:
    let
      jail = inputs.jail-nix.lib.init pkgs-unstable;
      inherit (jail) combinators;
      commonPkgs = with pkgs-unstable; [
        bashInteractive
        curl
        wget
        jq
        git
        which
        ripgrep
        gnugrep
        gawkInteractive
        ps
        findutils
        gzip
        unzip
        gnutar
        diffutils
        nix
      ];
      commonCombinators = with combinators; [
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
        (add-pkg-deps commonPkgs)
      ];

    in
    {
      packages.opencode = jail "opencode" pkgs-unstable.opencode (
        commonCombinators
        ++ (with combinators; [
          (add-runtime ''
            mkdir -p "$HOME/.config/opencode" "$HOME/.local/share/opencode"
          '')
          (try-readwrite (noescape "~/.config/opencode"))
          (try-readwrite (noescape "~/.local/share/opencode"))
        ])
      );
    };
}
