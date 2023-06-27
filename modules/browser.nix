{ config, lib, pkgs, ... }:
let
  # hack to make programs.chromium.commandLineArgs work for brave
  brave = pkgs.brave.override {
    commandLineArgs = lib.concatStringsSep " " config.home-manager.users.christian.programs.chromium.commandLineArgs;
  };
in {
  home-manager.users.christian.programs.chromium = {
    enable = true;
    package = brave;
    extensions = [
      { id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; } # 1password
      { id = "fihnjjcciajhdojfnbdddfaoknhalnja"; } # i dont care about cookies
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      { id = "nhdogjmejiglipccpnnnanhbledajbpd"; } # vue.js devtools
    ];
    # This option only works for chromium
    # TODO: fix this in https://github.com/nix-community/home-manager/blob/master/modules/programs/chromium.nix#L173
    commandLineArgs = [
      "--remote-debugging-port=9222"
    ];
  };
}
