{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  graphics = config.modules.graphics;

  cfg = config.modules.browser;

  username = import ../../username.nix;
in {
  options.modules.browser.firefox = {
    enable = mkOption {
      type = types.bool;
      description = "Enable or not Firefox. Enabled by default.";
      default = true;
      example = false;
    };
  };

  config = mkIf (cfg.firefox.enable && (graphics.type != null)) {
    home-manager.users.${username}.home.packages = with pkgs; [
      (wrapFirefox firefox-esr-115-unwrapped {
        # see https://github.com/mozilla/policy-templates/blob/master/README.md
        extraPolicies = {
          CaptivePortal = false;
          DisableFirefoxStudies = true;
          DisablePocket = true;
          DisableTelemetry = true;
          DisableFirefoxAccounts = true;
          DisableFormHistory = true;
          DisplayBookmarksToolbar = true;
          DontCheckDefaultBrowser = true;
          SearchEngines = {
            Add = [
              {
                Name = "Sourcegraph/Nix";
                Description = "Sourcegraph nix search";
                Alias = "!snix";
                Method = "GET";
                URLTemplate = "https://sourcegraph.com/search?q=context:global+file:.nix%24+{searchTerms}&patternType=literal";
              }
              {
                Name = "Searxng";
                Description = "Decentralized search engine";
                Alias = "sx";
                Method = "GET";
                URLTemplate = "https://search.notashelf.dev/search?q={searchTerms}";
              }
              {
                Name = "Torrent search";
                Description = "Searching for Creative Common musics";
                Alias = "!torrent";
                Method = "GET";
                URLTemplate = "https://librex.beparanoid.de/search.php?q={searchTerms}&t=3&p=0";
              }
              {
                Name = "Stackoverflow";
                Description = "Stealing code";
                Alias = "!so";
                Method = "GET";
                URLTemplate = "https://stackoverflow.com/search?q={searchTerms}";
              }
              {
                Name = "Wikipedia";
                Description = "Wikiless";
                Alias = "!wiki";
                Method = "GET";
                URLTemplate = "https://wikiless.org/w/index.php?search={searchTerms}title=Special%3ASearch&profile=default&fulltext=1";
              }
              {
                Name = "nixpkgs";
                Description = "Nixpkgs query";
                Alias = "!nix";
                Method = "GET";
                URLTemplate = "https://search.nixos.org/packages?&query={searchTerms}";
              }
              {
                Name = "Librex";
                Description = "A privacy respecting free as in freedom meta search engine for Google and popular torrent sites ";
                Alias = "!librex";
                Method = "GET";
                URLTemplate = "https://librex.beparanoid.de/search.php?q={searchTerms}&p=0&t=0";
              }
              {
                Name = "DeepL";
                Description = "Translator";
                Alias = "!t";
                Method = "GET";
                URLTemplate = "https://www.deepl.com/en/translator#en/fr/{searchTerms}%0A";
              }
            ];
            Default = "DuckDuckGo";
            Remove = mkForce [
              "Google"
              "Bing"
              "Amazon.com"
              "eBay"
              "Twitter"
              "Wikipedia"
            ];
          };

          ExtensionSettings = let
            mkForceInstalled = extensions:
              builtins.mapAttrs
              (name: cfg: {installation_mode = "force_installed";} // cfg)
              extensions;
          in
            mkForceInstalled {
              # Addon IDs are in manifest.json or manifest-firefox.json
              "{446900e4-71c2-419f-a6a7-df9c091e268b}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
              "addon@darkreader.org".install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
              "uBlock0@raymondhill.net".install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
              "{36bdf805-c6f2-4f41-94d2-9b646342c1dc}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/export-cookies-txt/latest.xpi";
              "{74145f27-f039-47ce-a470-a662b129930a}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi";
              "DontFuckWithPaste@raim.ist".install_url = "https://addons.mozilla.org/firefox/downloads/latest/don-t-fuck-with-paste/latest.xpi";
              "skipredirect@sblask".install_url = "https://addons.mozilla.org/firefox/downloads/latest/skip-redirect/latest.xpi";
              "sponsorBlocker@ajay.app".install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
              "7esoorv3@alefvanoon.anonaddy.me".install_url = "https://addons.mozilla.org/firefox/downloads/latest/libredirect/latest.xpi";
              "1018e4d6-728f-4b20-ad56-37578a4de76".install_url = "https://addons.mozilla.org/firefox/downloads/latest/flagfox/latest.xpi";
              "4a4ada26-0954-465c-bb5d-8c186d46a280".install_url = "https://addons.mozilla.org/firefox/downloads/file/4061156/pywalfox-2.0.11.xpi";
              "{762f9885-5a13-4abd-9c77-433dcd38b8fd}".install_url = "https://addons.mozilla.org/firefox/downloads/file/4114817/styl_us-1.5.33.xpi";
            };

          FirefoxHome = {
            Pocket = false;
            Snippets = false;
          };

          UserMessaging = {
            ExtensionRecommendations = false;
            SkipOnboarding = true;
          };

          SanitizeOnShutdown = {
            Cache = true;
            History = true;
            Cookies = true;
            Downloads = true;
            FormData = true;
            Sessions = true;
            OfflineApps = true;
          };

          PasswordManagerEnabled = true;
          PromptForDownloadLocation = false;

          Preferences = {
            "browser.toolbars.bookmarks.visibility" = "never";
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "browser.uidensity" = 1;
            # "browser.startup.homepage" = "file://${./startpage.html}";
            "general.useragent.override" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36";

            "extensions.update.enabled" = false;
            "intl.locale.matchOS" = true;

            "media.eme.enabled" = true;
          };
        };
      })
    ];
  };
}
