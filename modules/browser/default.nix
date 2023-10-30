{
  config,
  lib,
  inputs,
  pkgs,
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
  imports = [
    ./options.nix
  ];

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
      imports = [inputs.schizofox.homeManagerModules.default];

      xdg.mimeApps = {
        enable = true;
        associations.added = associations;
        defaultApplications = associations;
      };

      programs.schizofox = {
        enable = true;

        package = pkgs.firefox-esr-115-unwrapped;

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
              Alias = "!pkgs";
              Method = "GET";
              URLTemplate = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={searchTerms}";
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
          sanitizeOnShutdown = true;
          sandbox = false;
          userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:106.0) Gecko/20100101 Firefox/106.0";
        };

        misc = {
          drmFix = false;
          disableWebgl = false;
          startPageURL = "https://cloud.vagahbond.com";
        };

        extensions.extraExtensions = {
          "{446900e4-71c2-419f-a6a7-df9c091e268b}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          "addon@darkreader.org".install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          "uBlock0@raymondhill.net".install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          "{74145f27-f039-47ce-a470-a662b129930a}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi";
          "DontFuckWithPaste@raim.ist".install_url = "https://addons.mozilla.org/firefox/downloads/latest/don-t-fuck-with-paste/latest.xpi";
          "skipredirect@sblask".install_url = "https://addons.mozilla.org/firefox/downloads/latest/skip-redirect/latest.xpi";
          "sponsorBlocker@ajay.app".install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
          "7esoorv3@alefvanoon.anonaddy.me".install_url = "https://addons.mozilla.org/firefox/downloads/latest/libredirect/latest.xpi";
          "{762f9885-5a13-4abd-9c77-433dcd38b8fd}".install_url = "https://addons.mozilla.org/firefox/downloads/file/4114817/styl_us-1.5.33.xpi";
          "webextension@metamask.io".install_url = "https://addons.mozilla.org/firefox/downloads/latest/ether-metamask/latest.xpi";
        };

        misc.bookmarks = [
          {
            Title = "Dedistonks";
            URL = "https://sd-158943.dedibox.fr:8006/#v1:0:=node%2Fdedistonks:4:5:=contentImages::::12:5";
            Placement = "toolbar";
          }
          {
            Title = "Plex";
            URL = "https://plex.flavien-fouqueray.fr";
            Placement = "toolbar";
          }
          {
            Title = "Edusign";
            URL = "https://edusign.app/professor/";
            Placement = "toolbar";
            folder = "Courses";
          }
          {
            Title = "Gists";
            URL = "https://gist.github.com/vagahbond";
            Placement = "toolbar";
          }
          {
            Title = "Github";
            URL = "https://github.com/Vagahbond";
            Placement = "toolbar";
          }
        ];
      };
    };
  };
}
