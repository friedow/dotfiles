{
  flake.modules.nixos.workspace-apps =
    {
      config,
      pkgs,
      pkgs-unstable,
      lib,
      ...
    }:
    let
      firefox = config.home-manager.users.christian.programs.firefox;

      # Web apps are Firefox Taskbar Tabs: windows of the default profile with
      # their own app id "firefox-<name>", taken from shortcutRelativePath.
      web-apps = {
        mattermost = {
          id = "110f3db1-953b-4256-a31f-8c65261fc256";
          url = "https://mattermost.apm-ecampus.de/";
          workspace = "chat";
        };
        teams = {
          id = "73bf5d7c-2a09-4392-b934-8859ce4dda5f";
          url = "https://teams.microsoft.com/v2/";
          workspace = "chat";
        };
        proton-mail = {
          id = "1ffb74bb-226c-4198-90c8-e7db1be04a47";
          url = "https://mail.proton.me/u/12/inbox";
          workspace = "mail";
        };
        outlook-mail = {
          id = "614da43b-f9b3-4a8e-bb30-5f179b9703aa";
          url = "https://outlook.cloud.microsoft/mail/";
          workspace = "mail";
        };
        outlook-mail-dev = {
          id = "dc39b214-01c6-40a2-b26d-ffe25dec6be6";
          url = "https://outlook.cloud.microsoft/mail/dev@a-ue.de/";
          workspace = "mail";
        };
        proton-calendar = {
          id = "a4edefbc-92d4-4783-947b-d7db8eb432d3";
          url = "https://calendar.proton.me/u/12/";
          workspace = "event";
        };
        outlook-calendar = {
          id = "cac8a131-7299-4fc8-bd8c-fad5bf319f9b";
          url = "https://outlook.cloud.microsoft/calendar/view/month";
          workspace = "event";
        };
        spotify = {
          id = "950fdfea-0f36-41f2-af83-44098d84ecdc";
          url = "https://open.spotify.com/";
          workspace = "utils";
        };
        personio = {
          id = "960e1ab6-a6ce-4e67-a61b-3fcedecd7953";
          url = "https://apm-pflegehelden.app.personio.com/";
          workspace = "utils";
        };
      };

      ensure-app = pkgs.writeShellApplication {
        name = "ensure-app";
        runtimeInputs = [
          pkgs.niri
          pkgs.jq
        ];
        text = ''
          app_id="$1"
          shift

          if ! niri msg --json windows \
            | jq -e --arg app_id "$app_id" 'any(.[]; .app_id | test($app_id))' >/dev/null; then
            "$@" >/dev/null 2>&1 &
          fi
        '';
      };

      # Firefox's Taskbar Tabs registry, also the lookup table for ensure-web-app
      taskbar-tabs = (pkgs.formats.json { }).generate "taskbartabs.json" {
        version = 1;
        taskbarTabs = lib.mapAttrsToList (name: app: {
          inherit (app) id;
          inherit name;
          scopes = [ { hostname = builtins.head (builtins.match "https://([^/]+)/.*" app.url); } ];
          userContextId = 0;
          startUrl = app.url;
          shortcutRelativePath = "firefox-${name}.desktop";
        }) web-apps;
      };

      # Waits for the window, so the next web app reaches the running Firefox
      # instead of racing it for the profile lock when Firefox wasn't running.
      ensure-web-app = pkgs.writeShellApplication {
        name = "ensure-web-app";
        runtimeInputs = [
          pkgs.niri
          pkgs.jq
          pkgs.coreutils
          firefox.finalPackage
        ];
        runtimeEnv.TASKBAR_TABS = "${taskbar-tabs}";
        text = ''
          name="$1"
          app=$(jq -ec --arg name "$name" '.taskbarTabs[] | select(.name == $name)' "$TASKBAR_TABS")
          id=$(jq -r .id <<<"$app")
          url=$(jq -r .startUrl <<<"$app")

          has_window() {
            niri msg --json windows \
              | jq -e --arg app_id "firefox-$name" 'any(.[]; .app_id == $app_id)' >/dev/null
          }

          if ! has_window; then
            firefox -taskbar-tab "$id" -new-window "$url" -container 0 >/dev/null 2>&1 &
            for _ in {1..300}; do
              has_window && break
              sleep 0.1
            done
          fi
        '';
      };

      launch-chat = pkgs.writeShellApplication {
        name = "launch-chat";
        runtimeInputs = [
          pkgs.niri
          pkgs.beeper
          ensure-app
          ensure-web-app
        ];
        text = ''
          niri msg action focus-workspace chat
          ensure-web-app mattermost
          ensure-web-app teams
          ensure-app Beeper beeper
        '';
      };

      launch-mail = pkgs.writeShellApplication {
        name = "launch-mail";
        runtimeInputs = [
          pkgs.niri
          ensure-web-app
        ];
        text = ''
          niri msg action focus-workspace mail
          ensure-web-app proton-mail
          ensure-web-app outlook-mail
          ensure-web-app outlook-mail-dev
        '';
      };

      launch-event = pkgs.writeShellApplication {
        name = "launch-event";
        runtimeInputs = [
          pkgs.niri
          ensure-web-app
        ];
        text = ''
          niri msg action focus-workspace event
          ensure-web-app proton-calendar
          ensure-web-app outlook-calendar
        '';
      };

      launch-utils = pkgs.writeShellApplication {
        name = "launch-utils";
        runtimeInputs = [
          pkgs.niri
          pkgs-unstable._1password-gui
          ensure-app
          ensure-web-app
        ];
        text = ''
          niri msg action focus-workspace utils
          ensure-app 1password 1password --ozone-platform-hint=auto
          ensure-web-app spotify
          ensure-web-app personio
        '';
      };
    in
    {
      home-manager.users.christian = {
        programs.firefox.profiles.default.settings."browser.taskbarTabs.enabled" = true;

        # Read-only: Firefox only writes this file when web apps are added or
        # removed in the UI, which then fails and lasts until restart.
        home.file."${firefox.configPath}/${firefox.profiles.default.path}/taskbartabs/taskbartabs.json" = {
          force = true;
          source = taskbar-tabs;
        };

        # niri rejects a second binds block in config.kdl, but merges included files
        home.file.".config/niri/config.kdl".text = ''
          include "workspace-apps.kdl"
        '';

        home.file.".config/niri/workspace-apps.kdl".text = ''
          workspace "chat"
          workspace "mail"
          workspace "event"
          workspace "utils"

          binds {
              Super+U { spawn "${lib.getExe launch-chat}"; }
              Super+I { spawn "${lib.getExe launch-mail}"; }
              Super+O { spawn "${lib.getExe launch-event}"; }
              Super+P { spawn "${lib.getExe launch-utils}"; }
          }

          window-rule {
              match app-id=r#"^Beeper$"#
              open-on-workspace "chat"
              open-focused false
          }

          window-rule {
              match app-id=r#"^1password$"#
              open-on-workspace "utils"
              open-focused false
          }

          ${lib.concatStrings (
            lib.mapAttrsToList (name: app: ''
              window-rule {
                  match app-id=r#"^firefox-${name}$"#
                  open-on-workspace "${app.workspace}"
                  open-focused false
              }

            '') web-apps
          )}
        '';
      };
    };
}
