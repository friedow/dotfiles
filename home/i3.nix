{ config, pkgs, ... }:
let
  modifier = "Mod4";
in
{
	xsession.windowManager.i3 = {
		enable = true;

		config = {
			modifier = "${modifier}";
      
      startup = [
        { command = "albert"; notification = false; }
      ];
			
			keybindings = {
				"${modifier}+q" = "kill";

				"${modifier}+Left" = "focus left";
				"${modifier}+Down" = "focus down";
				"${modifier}+Up" = "focus up";
				"${modifier}+Right" = "focus right";

				"${modifier}+Shift+Left" = "move left";
				"${modifier}+Shift+Down" = "move down";
				"${modifier}+Shift+Up" = "move up";
				"${modifier}+Shift+Right" = "move right";

				"${modifier}+h" = "split h";
				"${modifier}+v" = "split v";
				"${modifier}+f" = "fullscreen toggle";

				"${modifier}+s" = "layout stacking";
				"${modifier}+w" = "layout tabbed";
				"${modifier}+e" = "layout toggle split";

				"${modifier}+Shift+space" = "floating toggle";

				"${modifier}+a" = "focus parent";

				"${modifier}+Shift+minus" = "move scratchpad";
				"${modifier}+minus" = "scratchpad show";

				"${modifier}+1" = "workspace number 1";
				"${modifier}+2" = "workspace number 2";
				"${modifier}+3" = "workspace number 3";
				"${modifier}+4" = "workspace number 4";
				"${modifier}+5" = "workspace number 5";
				"${modifier}+6" = "workspace number 6";
				"${modifier}+7" = "workspace number 7";
				"${modifier}+8" = "workspace number 8";
				"${modifier}+9" = "workspace number 9";
				"${modifier}+0" = "workspace number 10";

				"${modifier}+Shift+1" = "move container to workspace number 1";
				"${modifier}+Shift+2" = "move container to workspace number 2";
				"${modifier}+Shift+3" = "move container to workspace number 3";
				"${modifier}+Shift+4" = "move container to workspace number 4";
				"${modifier}+Shift+5" = "move container to workspace number 5";
				"${modifier}+Shift+6" = "move container to workspace number 6";
				"${modifier}+Shift+7" = "move container to workspace number 7";
				"${modifier}+Shift+8" = "move container to workspace number 8";
				"${modifier}+Shift+9" = "move container to workspace number 9";
				"${modifier}+Shift+0" = "move container to workspace number 10";

				"${modifier}+Shift+c" = "reload";
				"${modifier}+Shift+r" = "restart";
				"${modifier}+Shift+e" = "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";

				"${modifier}+r" = "mode resize";

				"${modifier}+space" = "exec albert toggle";
				"${modifier}+Return" = "exec alacritty";
			};

			bars = [];
			
			gaps = {
				inner = 10;
				outer = 3;
			};
		};
	};
}
