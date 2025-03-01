{ pkgs, ... }:
{
  users.users.christian.shell = pkgs.xonsh;
  programs.xonsh.enable = true;

  home-manager.users.christian = {
    home.packages = with pkgs; [
      eza
      bat
      libwebp
      fzf
    ];

    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      carapace.enable = true;
    };

    home = {
      file.".xonshrc".text = ''
        $COMPLETIONS_CONFIRM = False
        $COMPLETIONS_DISPLAY = 'single'
        $PROMPT = '{BOLD_BLACK}>{RESET} '
        $RIGHT_PROMPT = '{BOLD_BLACK}{cwd}{RESET}'
        $UPDATE_COMPLETIONS_ON_KEYPRESS = True
        $XONSH_PROMPT_CURSOR_SHAPE = 'beam'

        aliases['bearer-inspect'] = 'echo $argv[1] | cut -d. -f2  | base64 --decode --ignore-garbage';
        aliases['cat'] = 'bat --theme OneHalfLight --paging never --style plain'
        aliases['l'] = 'eza --oneline --all --sort=type'
        aliases['ll'] = 'l'
        aliases['n'] = 'nix run @(["nixpkgs-unstable#{package}".format(package=package) for package in $args])'
        aliases['nd'] = 'nix develop -c $SHELL'
        aliases['nrs'] = 'sudo nixos-rebuild switch'
        aliases['ns'] = 'nix shell @(["nixpkgs-unstable#{package}".format(package=package) for package in $args])'
        aliases['python310env'] = 'docker run --rm -it -v "$PWD:/data" -v "$HOME/.config/gcloud:/root/.config/gcloud" python:3.10-bookworm bash -c "pip install --force-reinstall poetry==1.8.5 && poetry config virtualenvs.in-project true && poetry self add keyrings.google-artifactregistry-auth && cd /data && bash"'
        aliases['python311env'] = 'docker run --rm -it -v "$PWD:/data" -v "$HOME/.config/gcloud:/root/.config/gcloud" python:3.11-bookworm bash -c "pip install --force-reinstall poetry==1.8.5 && poetry config virtualenvs.in-project true && poetry self add keyrings.google-artifactregistry-auth && cd /data && bash"'
        aliases['python39env'] = 'docker run --rm -it -v "$PWD:/data" -v "$HOME/.config/gcloud:/root/.config/gcloud" python:3.9-bookworm bash -c "pip install --force-reinstall poetry==1.8.5 && poetry config virtualenvs.in-project true && poetry self add keyrings.google-artifactregistry-auth && cd /data && bash"'
        aliases['record-screen'] = 'mkdir -p $HOME/Videos/recordings && ${pkgs.wf-recorder}/bin/wf-recorder -a -g "$(${pkgs.slurp}/bin/slurp)" -f "$HOME/Videos/recordings/$(date).mp4"'
        aliases['yubikey-unlock'] = '${pkgs.yubikey-manager}/bin/ykman fido fingerprints list'
      '';

      file.".config/xonsh/rc.xsh".text = ''
        $CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
        $COMPLETIONS_CONFIRM = True
        exec($(carapace _carapace))
      '';
    };
  };
}
