{ pkgs, ... }:
{
  users.users.christian.shell = pkgs.fish;
  programs.fish.enable = true;

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
    };

    programs.fish = {
      enable = true;
      shellAliases = {
        l = "eza -l";
        ls = "eza -l";
        ll = "eza -l";
        nd = "nix develop -c $SHELL";
        nrs = "sudo nixos-rebuild switch";
        cat = "bat --theme OneHalfLight --paging never --style plain";
        record-screen = ''mkdir -p $HOME/Videos/recordings && ${pkgs.wf-recorder}/bin/wf-recorder -a -g "$(${pkgs.slurp}/bin/slurp)" -f "$HOME/Videos/recordings/$(date).mp4"'';
        yubikey-unlock = "${pkgs.yubikey-manager}/bin/ykman fido fingerprints list";
        gpu = "git push";
        gc = "git commit -m ";
        python39env = ''docker run --rm -it -v "$PWD:/data" -v "$HOME/.config/gcloud:/root/.config/gcloud" python:3.9-bookworm bash -c "pip install --force-reinstall poetry==1.8.5 && poetry config virtualenvs.in-project true && poetry self add keyrings.google-artifactregistry-auth && cd /data && bash"'';
        python310env = ''docker run --rm -it -v "$PWD:/data" -v "$HOME/.config/gcloud:/root/.config/gcloud" python:3.10-bookworm bash -c "pip install --force-reinstall poetry==1.8.5 && poetry config virtualenvs.in-project true && poetry self add keyrings.google-artifactregistry-auth && cd /data && bash"'';
        python311env = ''docker run --rm -it -v "$PWD:/data" -v "$HOME/.config/gcloud:/root/.config/gcloud" python:3.11-bookworm bash -c "pip install --force-reinstall poetry==1.8.5 && poetry config virtualenvs.in-project true && poetry self add keyrings.google-artifactregistry-auth && cd /data && bash"'';
      };

      functions = {
        n.body = "nix run nixpkgs#$argv[1] -- $argv[2..]";
        nu.body = "nix run nixpkgs-unstable#$argv[1] -- $argv[2..]";
        ns.body = "nix shell nixpkgs#$argv[1]";
        bearer-inspect.body = "echo $argv[1] | cut -d. -f2  | base64 --decode --ignore-garbage";
      };

      interactiveShellInit = ''
        set fish_greeting # Disable greeting

        function fish_prompt -d "Write out the prompt"
          printf '> '
        end
      '';

      plugins = [
        {
          name = "z";
          src = pkgs.fishPlugins.z.src;
        }
        {
          name = "forgit";
          src = pkgs.fishPlugins.forgit.src;
        }
      ];
    };
  };
}
