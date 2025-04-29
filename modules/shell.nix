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
        syntaxHighlighting.enable = true;

        initExtra = ''
          PS1='%F{blue}%B>%b%f '
        '';

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
