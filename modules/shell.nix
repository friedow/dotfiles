{
  pkgs,
  ...
}:
{
  users.defaultUserShell = pkgs.fish;
  programs.fish.enable = true;
  programs.command-not-found.enable = false;

  home-manager.users.christian = {
    home.packages = with pkgs; [
      libwebp
      man-pages-posix
      websocat
    ];

    home = {
      shell.enableFishIntegration = true;
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

      zoxide.enable = true;

      nix-your-shell.enable = true;

      fish = {
        enable = true;

        shellInit = ''
          set -g fish_greeting ""
          fish_vi_key_bindings
        '';

        interactiveShellInit = ''
          function _update_completions_from_path --on-variable PATH
              for bin_dir in $PATH
                  set completions_dir (path dirname $bin_dir)/share/fish/vendor_completions.d
                  if test -d $completions_dir; and not contains $completions_dir $fish_complete_path
                      set -ga fish_complete_path $completions_dir
                  end
              end
          end
          _update_completions_from_path
        '';

        functions = {
          fish_mode_prompt.body = "";

          fish_prompt.body = ''
            if test $status -eq 0
              set_color green
            else
              set_color red
            end
            echo -n "> "
            set_color normal
          '';

          fish_right_prompt.body = "echo $PWD";

          l.body = "ls -lah --group-directories-first $argv";

          n.body = ''
            nix run "nixpkgs#$argv[1]" -- $argv[2..]
          '';

          nu.body = ''
            nix run "nixpkgs-unstable#$argv[1]" -- $argv[2..]
          '';

          ns.body = ''
            set nixpkgs
            for pkg in $argv
              set nixpkgs $nixpkgs "nixpkgs#$pkg"
            end
            nix shell $nixpkgs
          '';

          record-screen.body = ''
            mkdir -p $HOME/Videos/recordings
            ${pkgs.wf-recorder}/bin/wf-recorder -a -g (${pkgs.slurp}/bin/slurp) -f "$HOME/Videos/recordings/"(date +%Y%m%d_%H%M%S)".mp4"
          '';

          bearer-inspect.body = ''
            echo $argv[1] | string split "." | head -n 2 | tail -n 1 | base64 --decode --ignore-garbage
          '';
        };

        shellAliases = {
          cat = "bat";
          ll = "l";
          man = "batman";
          nd = "nix develop";
          nrs = "sudo nixos-rebuild switch";
          yubikey-unlock = "${pkgs.yubikey-manager}/bin/ykman fido fingerprints list";
        };
      };
    };
  };
}
