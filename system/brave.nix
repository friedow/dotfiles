{ pkgs, ... }: {
  hm.programs.chromium = {
    enable = builtins.trace "hallo" true;
    package = pkgs.brave;
    extensions = [
      { id = "hdokiejnpimakedhajhdlcegeplioahd"; } # lastpass
      { id = "fihnjjcciajhdojfnbdddfaoknhalnja"; } # i dont care about cookies
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      { id = "nhdogjmejiglipccpnnnanhbledajbpd"; } # vue.js devtools
      { id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; } # 1password
    ];
  };
}
