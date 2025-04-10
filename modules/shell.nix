{ pkgs, ... }:
{
  users.users.christian.shell = pkgs.zsh;
  programs.zsh.enable = true;

  home-manager.users.christian = {
    home.packages = with pkgs; [
      eza
      bat
      libwebp
      fzf
    ];

    #home.shell.enableZshIntegration = true;

    programs = {
      atuin = {
        enable = true;
        enableZshIntegration = true;
      };

      direnv = {
        enable = true;
        nix-direnv.enable = true;
        enableZshIntegration = true;
      };

      carapace = {
        enable = true;
        enableZshIntegration = true;
      };

      zoxide = {
        enable = true;
        enableZshIntegration = true;
      };

      zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        initExtra = ''
          PS1='%F{blue}%B>%b%f '

          # fzf-tab Configuration
          # disable sort when completing `git checkout`
          zstyle ':completion:*:git-checkout:*' sort false
          # set descriptions format to enable group support
          # NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
          zstyle ':completion:*:descriptions' format '[%d]'
          # set list-colors to enable filename colorizing
          zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
          # force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
          zstyle ':completion:*' menu no
          # preview directory's content with eza when completing cd
          zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
          # custom fzf flags
          # NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
          zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
          # To make fzf-tab follow FZF_DEFAULT_OPTS.
          # NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
          zstyle ':fzf-tab:*' use-fzf-default-opts yes
          # switch group using `<` and `>`
          zstyle ':fzf-tab:*' switch-group '<' '>'
          # enable tmux popup
          zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
        '';

        plugins = [
          {
            name = "fzf-tab";
            src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
          }
        ];

        shellAliases = {
          cat = "bat --theme OneHalfLight --paging never --style plain";
          l = "eza --oneline --all --sort=type";
          ll = "l";
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
