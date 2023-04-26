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
    '';
  };
}
