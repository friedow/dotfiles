{ pkgs, ... }:

let
  greetd-session = (pkgs.writeShellScriptBin "greetd-session" ''
    source /etc/profile
    source /etc/profiles/per-user/$(whoami)/etc/profile.d/hm-session-vars.sh
    exec systemd-cat --identifier=sway sway --unsupported-gpu $@
  '');

in {
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
}
