{ ... }: {
  home-manager.users.christian.programs.nushell = {
    enable = true;

    extraConfig = ''
        let-env PROMPT_INDICATOR = "> "
        let-env PROMPT_COMMAND = ""
        let-env PROMPT_COMMAND_RIGHT = { $"(ansi green_bold)($env.PWD)" }

        let-env config = {
            show_banner: false
        }
    '';
  };
}
