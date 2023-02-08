{ pkgs, ... }: {
  
  home-manager.users.christian = {
    # home.file.brave-preferences = {
    #   source = ./Preferences;
    #   target = ".config/BraveSoftware/Brave-Browser/Default/Preferences";
    # };

    programs.chromium = {
      enable = true;
      package = pkgs.brave;
      extensions = [
        { id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; } # 1password
        { id = "fihnjjcciajhdojfnbdddfaoknhalnja"; } # i dont care about cookies
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
        { id = "nhdogjmejiglipccpnnnanhbledajbpd"; } # vue.js devtools
      ];
    };
  };
}
