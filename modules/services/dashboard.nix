{
  targets = [  ];

  nixosConfiguration =
    { config, ... }:
    {

      ###################################################
      # SECRETS                                         #
      ###################################################
      age.secrets = {
        glanceSecretKey = {
          file = ../../secrets/glance_secret_key.age;
        };

        glancePassword = {
          file = ../../secrets/glance_vagahbond_password.age;
        };
      };
      services = {
        nginx.virtualHosts."dash.vagahbond.com" = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString config.services.glance.settings.server.port}";
            proxyWebsockets = true; # needed if you need to use WebSocket
          };
        };

        glance = {
          enable = true;
          settings = {

            pages = [
              {
                name = "Home";
                columns = [
                  {
                    size = "small";
                    widgets = [
                      {
                        type = "clock";
                      }
                      {
                        type = "to-do";
                      }
                      {
                        type = "server-stats";
                        servers = [
                          {
                            type = "local";
                            name = "Server";
                          }
                        ];
                      }
                      {
                        type = "markets";
                        markets = [
                          {
                            symbol = "BTC-EUR";
                            name = "Bitcoin";
                            "chart-link" = "https://www.tradingview.com/chart/?symbol=INDEX:BTCEUR";
                          }
                          {
                            symbol = "ETH-EUR";
                            name = "Ethereum";
                            "chart-link" = "https://www.tradingview.com/chart/?symbol=INDEX:ETHEUR";
                          }

                        ];
                      }
                    ];
                  }
                  {
                    size = "full";
                    widgets = [
                      {
                        autofocus = true;
                        type = "search";
                        "search-engine" = "duckduckgo";
                        bangs = [
                          {
                            title = "Nix Package";
                            shortcut = "!np";
                            url = "https://search.nixos.org/packages?channel=unstable&query={QUERY}";
                          }
                          {
                            title = "Nix Options";
                            shortcut = "!no";
                            url = "https://search.nixos.org/options?channel=unstable&query={QUERY}";
                          }
                        ];
                      }
                      {
                        type = "bookmarks";
                        groups = [
                          {
                            title = "Tech";
                            links = [
                              {
                                title = "Github";
                                url = "https://github.com/";
                              }
                              {
                                title = "Nix documentation";
                                url = "https://nixos.org/manual/nix/stable/";
                              }
                            ];
                          }
                          {
                            title = "Entertainment";
                            links = [
                              {
                                title = "Netflix";
                                url = "https://www.netflix.com/";
                              }
                            ];
                          }
                        ];
                      }
                      {
                        type = "rss";
                        title = "News";
                        feeds = [
                          {
                            title = "Touches grasses";
                            url = "https://touches-grasses.fr/index.xml";
                          }
                          {
                            title = "Raptor";
                            url = "https://leraptor.fr/blogs/infos.atom";
                          }
                        ];
                      }
                    ];
                  }
                  {
                    size = "small";
                    widgets = [
                      {
                        title = "Services";
                        type = "monitor";
                        cache = "1m";
                        sites = [
                          {
                            icon = "si:homepage";
                            title = "Homepage";
                            url = "https://vagahbond.com";
                          }
                          {
                            icon = "mdi:gamepad-variant";
                            title = "MKReset";
                            url = "https://mkreset.fr";
                          }
                          {
                            icon = "si:nextcloud";
                            title = "Cloud";
                            url = "https://nuage.vagahbond.com";
                          }
                          {
                            icon = "sh:filestash";
                            title = "Files";
                            url = "https://files.vagahbond.com";
                          }
                          {
                            icon = "si:hugo";
                            title = "Touches grasses";
                            url = "https://touches-grasses.fr";
                          }
                          {
                            icon = "si:simpleanalytics";
                            title = "Touches grasses analytiques";
                            url = "https://analytics.touches-grasses.fr";
                          }
                          {
                            icon = "si:bitwarden";
                            title = "Pass";
                            url = "https://pass.vagahbond.com";
                          }
                          {
                            icon = "si:ente";
                            title = "Pics";
                            url = "https://pics.vagahbond.com";
                          }
                          {
                            icon = "si:grafana";
                            title = "Metrics";
                            url = "https://metrics.vagahbond.com";
                          }
                          {
                            icon = "si:dolibarr";
                            title = "Accounting";
                            url = "https://accounting.vagahbond.com";
                          }
                          {
                            icon = "si:affine";
                            title = "Notes";
                            url = "https://notes.vagahbond.com";
                          }
                        ];
                      }
                    ];
                  }
                ];
              }
            ];
            theme = {
              "disable-picker" = true;
              light = true;
              "background-color" = "44 87 94";
              "primary-color" = "68 99 32";
              "positive-color" = "201 55 50";
              "negative-color" = "1 92 65";
              "contrast-multiplier" = 1.4;
              presets = {
                "default-dark" = {
                  "background-color" = "206 13 20";
                  "primary-color" = "83 34 63";
                  "positive-color" = "172 31 62";
                  "negative-color" = "359 68 70";
                  "contrast-multiplier" = 1.4;
                };
                "default-light" = {
                  light = true;
                  "background-color" = "44 87 94";
                  "primary-color" = "68 99 32";
                  "positive-color" = "201 55 50";
                  "negative-color" = "1 92 65";
                  "contrast-multiplier" = 1.4;
                };
              };
            };
            server = {
              host = "127.0.0.1";
              port = 9981;
            };
            "auth" = {
              secret-key = {
                _secret = config.age.secrets.glanceSecretKey.path;
              };
              users = {
                vagahbond = {
                  password = {
                    _secret = config.age.secrets.glancePassword.path;
                  };
                };
              };
            };
          };
        };
      };
    };
}
