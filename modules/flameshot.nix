{ ... }: { 
    # Needs some adjustment after switching to wayland, probably just this:
    # https://github.com/flameshot-org/flameshot/blob/master/docs/Sway%20and%20wlroots%20support.md
    home-manager.users.christian.services.flameshot.enable = true;
}
