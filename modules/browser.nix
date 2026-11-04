{ inputs, ... }:
{
  flake.modules.nixos.browser =
    { pkgs, ... }:
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

        imports = [ inputs.zen-browser.homeModules.twilight ];
        programs.zen-browser = {
          enable = true;
          setAsDefaultBrowser = true;

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

              "browser.toolbars.bookmarks.visibility" = "always";
              "browser.translations.automaticallyPopup" = false;
              "browser.urlbar.suggest.clipboard" = false;
              "browser.urlbar.suggest.searches" = false;

              # handled by 1password
              "extensions.formautofill.addresses.enabled" = false;
              "extensions.formautofill.creditCards.enabled" = false;
              "signon.management.page.breach-alerts.enabled" = false;
              "signon.rememberSignons" = false;

              "network.dns.disablePrefetch" = true;
              "network.http.speculative-parallel-limit" = 0;
              "network.prefetch-next" = false;

              "zen.glance.enabled" = false;
              "zen.tabs.show-newtab-vertical" = false;
              "zen.view.compact.enable-at-startup" = true;
              "zen.view.show-newtab-button-top" = false;
              "zen.welcome-screen.seen" = true;
              "zen.workspaces.continue-where-left-off" = true;
            };
            search = {
              force = true;
              default = "kagi";
              engines.kagi = {
                name = "Kagi";
                urls = [ { template = "https://kagi.com/search?q={searchTerms}"; } ];
                definedAliases = [ "@k" ];
              };
            };
          };
        };
      };
    };
}
