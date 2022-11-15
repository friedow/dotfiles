{ config, pkgs, ... }: { 
    # Needs some adjustment after switching to wayland, probably just this:
    # https://github.com/flameshot-org/flameshot/blob/master/docs/Sway%20and%20wlroots%20support.md
    services.flameshot.enable = true;
}
