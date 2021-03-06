{ config, pkgs, ... }:
let
  modifier = "Mod4";
  colors = import /etc/nixos/config/colors.nix;
  fonts = import /etc/nixos/config/fonts.nix;
in
{
	xsession.windowManager.i3 = {
		enable = true;

		config = {
      # General
			modifier = "${modifier}";
		
			startup = [
				{ command = "lock"; notification = false; }
			];


      # Keybinds
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

				"${modifier}+Shift+Ctrl+Left" = "move workspace to output left";
				"${modifier}+Shift+Ctrl+Right" = "move workspace to output right";

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

				"${modifier}+k" = "exec sudo -u christian /home/christian/Code/friedow/search/tucan-search";
				"${modifier}+Return" = "exec alacritty";
        "${modifier}+Shift+s" = "exec flameshot gui";
        "${modifier}+l" = "exec lock";
			};


      # UI
      bars = [];
      
      colors = {
        focused = {
          background = colors.background.primary;
          border = colors.background.primary;
          childBorder = colors.highlight.gray;
          indicator = colors.highlight.gray;
          text = colors.text;
        };

        unfocused = {
          background = colors.background.secondary;
          border = colors.highlight.gray;
          childBorder = colors.highlight.gray;
          indicator = colors.highlight.gray;
          text = colors.text;
        };

        focusedInactive = {
          background = colors.background.secondary;
          border = colors.background.secondary;
          childBorder = colors.highlight.gray;
          indicator = colors.highlight.gray;
          text = colors.text;
        };
      };

			floating.border = 0;

			fonts = {
				names = [ fonts.sansSerif ];
				style = "";
				size = 15.0;
			};

      gaps = {
				inner = 2;
				outer = -2;
			};

			window = {
				border = 0;

				commands = [
					{ 
						command = "title_format \"<span size='9pt'>    %title</span>\"";
						criteria = { class = ".*"; }; 
					}
				];
			};
		};
	};
}
