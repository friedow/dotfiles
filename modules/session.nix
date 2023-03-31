{ inputs, pkgs, lib, config, ... }:
let
  greetd-session = if config.machine.usesNixGl then
    (pkgs.writeShellScriptBin "greetd-session" ''
      source /etc/profile
      source /etc/profiles/per-user/$(whoami)/etc/profile.d/hm-session-vars.sh
      exec systemd-cat --identifier=sway ${inputs.nixgl.packages.x86_64-linux.default}/bin/nixGL sway --unsupported-gpu $@
    '')
  else
    (pkgs.writeShellScriptBin "greetd-session" ''
      source /etc/profile
      source /etc/profiles/per-user/$(whoami)/etc/profile.d/hm-session-vars.sh
      exec systemd-cat --identifier=sway sway --unsupported-gpu $@
    '');
in {
  options.machine = {
    usesNixGl = lib.mkEnableOption "Wheter the mache uses nixGl on startup.";
  };

  config = {
    services.greetd = {
      enable = true;
      settings = {
        # on startup start sway directly (the hdd password was just entered on boot)
        initial_session = {
          command = "${greetd-session}/bin/greetd-session";
          user = "christian";
        };
        # by default, use agreety asking for a user password
        default_session = {
          command =
            "${pkgs.greetd.greetd}/bin/agreety --cmd ${greetd-session}/bin/greetd-session";
        };
      };
    };
  };
}
