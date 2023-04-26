{ pkgs, inputs, ... }: 
let 
  # TODO: import unstable packages globally
  pkgs-unstable = (import inputs.nixpkgs-unstable) {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
in {
  systemd.user.services.pueued = {
    wantedBy = ["default.target"];
    script = ''
      ${pkgs.pueue}/bin/pueued
    '';
  };
  home-manager.users.christian.programs.nushell = {
    enable = true;
    # TODO: use unstable package
    package = pkgs-unstable.nushell;

    extraConfig = ''
      let-env PROMPT_INDICATOR = "> "
      let-env PROMPT_COMMAND = ""
      let-env PROMPT_COMMAND_RIGHT = { $"(ansi green_bold)($env.PWD)" }

      let-env config = {
          show_banner: false
      }


      module job {
        # spawn task to run in the background
        #
        # please note that a fresh nushell is spawned to execute the given command
        # So it doesn't inherit current scope's variables, custom commands, alias definition, except env variables which value can convert to string.
        #
        # e.g:
        # spawn { echo 3 }
        export def spawn [
            command: block   # the command to spawn
        ] {
            let config_path = $nu.config-path
            let env_path = $nu.env-path
            let source_code = (view source $command | str trim -l -c '{' | str trim -r -c '}')
            let job_id = (${pkgs.pueue}/bin/pueue add -p $"nu --config \"($config_path)\" --env-config \"($env_path)\" -c '($source_code)'")
            {"job_id": $job_id}
        }

        export def log [
            id: int   # id to fetch log
        ] {
            ${pkgs.pueue}/bin/pueue log $id -f --json
            | from json
            | transpose -i info
            | flatten --all
            | flatten --all
            | flatten status
        }

        # get job running status
        export def status () {
            ${pkgs.pueue}/bin/pueue status --json
            | from json
            | get tasks
            | transpose -i status
            | flatten
            | flatten status
        }

        # kill specific job
        export def kill (id: int) {
            ${pkgs.pueue}/bin/pueue kill $id
        }

        # clean job log
        export def clean () {
            ${pkgs.pueue}/bin/pueue clean
        }
      }

      use job
    '';
  };
}
