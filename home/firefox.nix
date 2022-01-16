{ config, pkgs, ... }:
let
  search-engine = "about:home";
in
{
    nixpkgs.config.packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
        };
    };

	programs.firefox = {
        enable = true;
        package = pkgs.firefox-esr;

        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
            adsum-notabs
            lastpass-password-manager
            foxyproxy-standard
            ublock-origin
            vue-js-devtools
            i-dont-care-about-cookies
        ];
    
        profiles.christian = {
            userChrome = "
                #TabsToolbar {
                    visibility: collapse !important;
                }

                #back-button,
                #forward-button,
                #stop-reload-button,
                #tracking-protection-icon-container,
                #star-button-box,
                #downloads-button {
                    display: none !important;
                }
            ";

            settings = {
                "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
                "extensions.pocket.enabled" = false;
                "startup.homepage_welcome_url" = "${search-engine}";
                "browser.startup.homepage" = "${search-engine}";
                "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts" = false;
                "browser.newtabpage.activity-stream.feeds.topsites" = false;
                "browser.toolbars.bookmarks.visibility" = "never";
            };
        };
    };

}
