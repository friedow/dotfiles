{ config, pkgs, ... }:
{
  services.picom = {
    enable = true;
    fade = true;
    fadeDelta = 5;
    # TODO: Add window animations as soon as https://github.com/yshui/picom/pull/772
    # is merged into next. (recent issue: https://github.com/yshui/picom/issues/911)
    
    # picom window animations by syndrizzle
    # https://github.com/syndrizzle/hotfiles
    # extraOptions = ''
    #   animations: true;
    #   animation-stiffness = 200
    #   animation-window-mass = 0.4
    #   animation-dampening = 20
    #   animation-clamping = false
    #   animation-for-open-window = "zoom"; #open window
    #   animation-for-unmap-window = "zoom"; #minimize window
    #   animation-for-workspace-switch-in = "slide-down"; #the windows in the workspace that is coming in
    #   animation-for-workspace-switch-out = "zoom"; #the windows in the workspace that are coming out
    #   animation-for-transient-window = "slide-up"; #popup windows
    # '';
  };
}
