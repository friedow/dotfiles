{
  pkgs,
  lib,
  config,
  ...
}:
{
  environment.shells = [ pkgs.nushell ];

  programs.bash.interactiveShellInit = ''
    if ! [ "$TERM" = "dumb" ]; then
      exec nu
    fi
  '';

  home-manager.users.christian = {
    home.packages = with pkgs; [
      libwebp
      man-pages-posix
      tldr
    ];

    home = {
      shell.enableNushellIntegration = true;
    };

    services.tldr-update = {
      enable = true;
      package = pkgs.tealdeer;
    };

    programs = {
      atuin.enable = true;

      bat = {
        enable = true;
        extraPackages = with pkgs.bat-extras; [
          batman
        ];
      };

      # carapace.enable = true;

      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      eza.enable = true;

      fzf.enable = true;

      jq.enable = true;

      zoxide.enable = true;

      nushell = {
        enable = true;

        extraConfig = ''

          $env.config.show_banner = false

        '';

        # initContent = ''
        #   PS1='%F{blue}%B>%b%f '
        #
        #   # enable carapace completion
        #   zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
        #   source <(carapace _carapace)
        # '';
        #
        # shellAliases = {
        # cat = "bat";
        #   l = "eza --oneline --all --sort=type";
        #   ll = "l";
        # man = "batman";
        #   nd = "nix develop -c $SHELL";
        # nrs = "sudo nixos-rebuild switch";
        #   record-screen = ''mkdir -p $HOME/Videos/recordings && ${pkgs.wf-recorder}/bin/wf-recorder -a -g "$(${pkgs.slurp}/bin/slurp)" -f "$HOME/Videos/recordings/$(date).mp4"'';
        #   yubikey-unlock = "${pkgs.yubikey-manager}/bin/ykman fido fingerprints list";
        #   n = ''() { package=$1; shift; nix run nixpkgs-unstable#$package -- $@ }'';
        #   ns = ''() { packages=(); for arg in $@; do packages+="nixpkgs-unstable#$arg"; done; nix shell $packages }'';
        #   bearer-inspect = ''() { echo $1 | cut -d. -f2  | base64 --decode --ignore-garbage }'';
        # };
      };
    };
  };
}
