{
  config,
  lib,
  inputs,
  ...
}:
with lib; let
  inherit (config.modules) graphics impermanence;
  cfg = config.modules.browser;

  username = import ../../username.nix;

  browser = ["firefox.desktop"];

  associations = {
    "text/html" = browser;
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/ftp" = browser;
    "x-scheme-handler/about" = browser;
    "x-scheme-handler/unknown" = browser;
    "application/x-extension-htm" = browser;
    "application/x-extension-html" = browser;
    "application/x-extension-shtml" = browser;
    "application/xhtml+xml" = browser;
    "application/x-extension-xhtml" = browser;
    "application/x-extension-xht" = browser;
  };
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
    environment.persistence.${impermanence.storageLocation} = {
      users.${username} = {
        directories = [
          ".mozilla"
          ".cache/mozilla"
        ];
      };
    };

    home-manager.users.${username} = {...}: {
      imports = [inputs.internalFlakes.browser.schizofox.homeManagerModules.default];

      xdg.mimeApps = {
        enable = true;
        associations.added = associations;
        defaultApplications = associations;
      };

      programs.schizofox = {
        enable = true;

        # theme = {
        #   background-darker = "181825";
        #   background = "1e1e2e";
        #   foreground = "cdd6f4";
        #   font = "Lexend";
        #   simplefox.enable = true;
        #   darkreader.enable = true;
        #   extraCss = ''
        #     body {
        #       color: red !important;
        #     }
        #   '';
        # };

        search = {
          defaultSearchEngine = "DuckDuckGo";
          removeEngines = ["Google" "Bing" "Amazon.com" "eBay" "Twitter" "Wikipedia"];
          searxUrl = "https://searx.be";
          searxQuery = "https://searx.be/search?q={searchTerms}&categories=general";
          addEngines = [
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
              Name = "Etherscan";
              Description = "Checking balances";
              Alias = "!eth";
              Method = "GET";
              URLTemplate = "https://etherscan.io/search?f=0&q={searchTerms}";
            }
            {
              Name = "DeepL";
              Description = "Translator";
              Alias = "!t";
              Method = "GET";
              URLTemplate = "https://www.deepl.com/en/translator#en/fr/{searchTerms}%0A";
            }
          ];
        };

        security = {
          sanitizeOnShutdown = false;
          sandbox = true;
          userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:106.0) Gecko/20100101 Firefox/106.0";
        };

        misc = {
          drmFix = true;
          disableWebgl = false;
          startPageURL = "https://www.notion.so/vagahbond/Personal-Home-b254100e4ec947ae893ffffb0951e339";
        };

        extensions.extraExtensions = {
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
          "webextension@metamask.io".install_url = "https://addons.mozilla.org/firefox/downloads/latest/ether-metamask/latest.xpi";
        };

        # bookmarks = [
        #  {
        #    Title = "Example";
        #    URL = "https://example.com";
        #    Favicon = "https://example.com/favicon.ico";
        #    Placement = "toolbar";
        #    Folder = "FolderName";
        #  }
        #];
      };
    };
  };
}
