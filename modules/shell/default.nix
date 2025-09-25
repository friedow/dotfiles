{
  pkgs,
  ...
}:
{
  environment.shells = [ pkgs.nushell ];

  programs.bash.interactiveShellInit = ''
    if ! [ "$TERM" = "dumb" ]; then
      exec nu
    fi
  '';

  programs.command-not-found.enable = false;

  home-manager.users.christian = {
    home.packages = with pkgs; [
      libwebp
      man-pages-posix
      tldr
      websocat
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

      carapace.enable = true;

      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      zoxide.enable = true;

      nix-your-shell.enable = true;

      nushell = {
        enable = true;

        extraConfig = ''
          $env.config.show_banner = false
          $env.config.hooks.command_not_found = source ${./command-not-found.nu}
          $env.PROMPT_COMMAND = null
          $env.PROMPT_COMMAND_RIGHT = {|| $env.PWD }

          $env.config.edit_mode = 'vi'

          $env.config.keybindings ++= [
            {
              name: ide_completion_menu
              modifier: None
              keycode: Tab
              mode: [emacs vi_insert vi_normal]
              event: {
                until: [
                  { send: menu name: ide_completion_menu }
                ]
              }
            }
          ]

          def l [] { ls --all | sort-by type }

          def n [pkg: string, ...args: string] {
            nix run $"nixpkgs#($pkg)" -- ...$args
          }

          def ns [...pkgs: string] {
            let nixpkgs = $pkgs | each { |pkg| $"nixpkgs#($pkg)" }
            nix shell ...$nixpkgs
          }

          def record-screen [] {
            mkdir $env.HOME/Videos/recordings
            ${pkgs.wf-recorder}/bin/wf-recorder -a -g "$(${pkgs.slurp}/bin/slurp)" -f "$HOME/Videos/recordings/$(date).mp4"
          };

          def bearer-inspect [token: string] {
            $token | split column "." | get column2.0 | base64 --decode --ignore-garbage
          }
        '';

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
