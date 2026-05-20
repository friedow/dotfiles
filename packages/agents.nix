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
        (try-readonly (noescape "/etc/nix/nix.conf"))
        (try-readonly (noescape "/nix/store"))
        (try-fwd-env "NO_COLOR")
        (try-fwd-env "TERM")
        (add-pkg-deps commonPkgs)
      ];
    in
    {
      packages.claude-code = jail "claude" pkgs-unstable.claude-code (
        commonCombinators
        ++ (with combinators; [
          (try-readwrite (noescape "~/.claude"))
          (try-readwrite (noescape "~/.claude.json"))
        ])
      );

      packages.codex = jail "codex" pkgs-unstable.codex (
        commonCombinators
        ++ (with combinators; [
          (try-readwrite (noescape "~/.codex"))
        ])
      );

    };

}
