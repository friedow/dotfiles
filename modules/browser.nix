{ self, ... }:
{
  flake.modules.nixos.browser =
    { lib, pkgs, ... }:
    {
      home-manager.users.christian = {
        programs.chromium = {
          enable = true;
          package = pkgs.brave;
          extensions = [
            { id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; } # 1password
            { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # vimium
            { id = "iaiomicjabeggjcfkbimgmglanimpnae"; } # Tab Session Manager
            { id = "aghdiknflpelpkepifoplhodcnfildao"; } # Save Tab Groups for Tab Session Manager
          ];
        };

        # xdg.mimeApps = {
        #   enable = true;
        #   defaultApplications = lib.genAttrs [
        #     "application/json"
        #     "application/x-extension-htm"
        #     "application/x-extension-html"
        #     "application/x-extension-shtml"
        #     "application/x-extension-xht"
        #     "application/x-extension-xhtml"
        #     "application/xhtml+xml"
        #     "text/html"
        #     "text/plain"
        #     "x-scheme-handler/about"
        #     "x-scheme-handler/chrome"
        #     "x-scheme-handler/http"
        #     "x-scheme-handler/https"
        #     "x-scheme-handler/mailto"
        #     "x-scheme-handler/unknown"
        #   ] (_: "firefox.desktop");
        # };

        stylix.targets.firefox.profileNames = [ "default" ];

        programs.firefox = {
          enable = true;
          configPath = ".mozilla/firefox";
          package = self.packages.x86_64-linux.firefox-no-tabs;

          policies.ExtensionSettings =
            let
              amo = slug: {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";
                installation_mode = "force_installed";
              };
            in
            {
              "{d634138d-c276-4fc8-924b-40a0ea21d284}" = amo "1password-x-password-manager";
              "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = amo "vimium-ff";
              "uBlock0@raymondhill.net" = amo "ublock-origin";
            };

          profiles.default = {
            settings = {
              "media.navigator.permission.disabled" = true;
              "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;

              "browser.toolbars.bookmarks.visibility" = "never";
              "browser.translations.automaticallyPopup" = false;
              "browser.translations.enable" = false;
              "browser.urlbar.suggest.clipboard" = false;
              "browser.touchmode.auto" = false;
              "browser.shell.checkDefaultBrowser" = false;
              "identity.fxaccounts.toolbar.appMenuSignInPromo.dismissed" = true;

              # startup: restore previous session, blank home and new tab page
              "browser.startup.page" = 3;
              "browser.startup.homepage" = "chrome://browser/content/blanktab.html";
              "browser.newtabpage.enabled" = false;

              # toolbar layout (Customize Toolbar)
              "browser.uiCustomization.state" = builtins.toJSON {
                placements = {
                  widget-overflow-fixed-list = [ ];
                  unified-extensions-area = [ "_d634138d-c276-4fc8-924b-40a0ea21d284_-browser-action" ];
                  nav-bar = [
                    "back-button"
                    "forward-button"
                    "vertical-spacer"
                    "urlbar-container"
                    "customizableui-special-spring2"
                    "reset-pbm-toolbar-button"
                    "downloads-button"
                    "_d634138d-c276-4fc8-924b-40a0ea21d284_-browser-action"
                    "unified-extensions-button"
                  ];
                  toolbar-menubar = [ "menubar-items" ];
                  TabsToolbar = [
                    "tabbrowser-tabs"
                    "new-tab-button"
                    "customizableui-special-spring3"
                    "alltabs-button"
                    "smartwindow-group-tabs-button"
                    "ai-window-toggle"
                  ];
                  vertical-tabs = [ ];
                  PersonalToolbar = [ "personal-bookmarks" ];
                };
                seen = [
                  "reset-pbm-toolbar-button"
                  "smartwindow-group-tabs-button"
                  "ai-window-toggle"
                  "developer-button"
                  "screenshot-button"
                  "_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action"
                  "ublock0_raymondhill_net-browser-action"
                  "_d634138d-c276-4fc8-924b-40a0ea21d284_-browser-action"
                ];
                dirtyAreaCache = [
                  "nav-bar"
                  "TabsToolbar"
                  "vertical-tabs"
                  "PersonalToolbar"
                  "unified-extensions-area"
                  "toolbar-menubar"
                ];
                currentVersion = 28;
                newElementCount = 5;
              };

              # devtools open in their own window (no tabs to dock into)
              "devtools.toolbox.host" = "window";
              "devtools.responsive.reloadNotification.enabled" = false;

              # AI features
              "browser.ai.control.default" = "blocked";
              "browser.ai.control.linkPreviewKeyPoints" = "blocked";
              "browser.ai.control.pdfjsAltText" = "blocked";
              "browser.ai.control.sidebarChatbot" = "blocked";
              "browser.ai.control.smartTabGroups" = "blocked";
              "browser.ai.control.smartWindow" = "blocked";
              "browser.ai.control.speechRecognition" = "blocked";
              "browser.ai.control.translations" = "blocked";
              "browser.ml.chat.enabled" = false;
              "browser.ml.chat.page" = false;
              "browser.ml.linkPreview.enabled" = false;
              "browser.smartwindow.memories.generateFromConversation" = false;
              "browser.smartwindow.memories.generateFromHistory" = false;
              "browser.tabs.groups.smart.enabled" = false;
              "browser.tabs.groups.smart.userEnabled" = false;
              "extensions.ml.enabled" = false;
              "pdfjs.enableAltText" = false;

              # privacy, telemetry and recommendations
              "privacy.globalprivacycontrol.enabled" = true;
              "datareporting.healthreport.uploadEnabled" = false;
              "datareporting.usage.uploadEnabled" = false;
              "nimbus.rollouts.enabled" = false;
              "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
              "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;

              # handled by 1password
              "extensions.formautofill.addresses.enabled" = false;
              "extensions.formautofill.creditCards.enabled" = false;
              "signon.management.page.breach-alerts.enabled" = false;
              "signon.rememberSignons" = false;

              # firefox-no-tabs: without a tab bar, drop the empty titlebar row
              # and don't restore multi-tab sessions whose tabs would be hidden
              "browser.tabs.inTitlebar" = 0;
              "browser.sessionstore.resume_from_crash" = false;
            };
            search = {
              force = true;
              default = "kagi";
              order = [ "kagi" ];
              engines = {
                kagi = {
                  name = "Kagi";
                  urls = [ { template = "https://kagi.com/search?q={searchTerms}"; } ];
                  definedAliases = [ "@k" ];
                };
              }
              # hide Firefox's built-in engines (region DE, locales en-US/de,
              # from search-config-v2.json in browser/omni.ja of Firefox 159)
              //
                lib.genAttrs
                  [
                    "bing"
                    "ddg"
                    "ebay-de"
                    "ecosia"
                    "google"
                    "leo_ende_de"
                    "perplexity"
                    "reddit"
                    "startpage"
                    "wikipedia"
                    "wikipedia-de"
                    "youtube"
                  ]
                  (_: {
                    metaData.hidden = true;
                  });
            };
          };
        };
      };
    };
}
