{ pkgs, ... }:
{
  users.users.christian.shell = pkgs.zsh;
  programs.zsh.enable = true;

  home-manager.users.christian = {
    home.packages = with pkgs; [
      libwebp
      man-pages-posix
      tldr
    ];

    home = {
      shell.enableZshIntegration = true;
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

      carapace.enable = true;

      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      eza.enable = true;

      fzf.enable = true;

      jq.enable = true;

      zoxide.enable = true;

      zsh = {
        enable = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;

        initContent = ''
          PS1='%F{blue}%B>%b%f '
        '';

        shellAliases = {
          cat = "bat";
          l = "eza --oneline --all --sort=type";
          ll = "l";
          man = "batman";
          nd = "nix develop -c $SHELL";
          nrs = "sudo nixos-rebuild switch";
          record-screen = ''mkdir -p $HOME/Videos/recordings && ${pkgs.wf-recorder}/bin/wf-recorder -a -g "$(${pkgs.slurp}/bin/slurp)" -f "$HOME/Videos/recordings/$(date).mp4"'';
          yubikey-unlock = "${pkgs.yubikey-manager}/bin/ykman fido fingerprints list";
          n = ''() { package=$1; shift; nix run nixpkgs-unstable#$package -- $@ }'';
          ns = ''() { packages=(); for arg in $@; do packages+="nixpkgs-unstable#$arg"; done; nix shell $packages }'';
          bearer-inspect = ''() { echo $1 | cut -d. -f2  | base64 --decode --ignore-garbage }'';
        };
      };
    };
  };
}
