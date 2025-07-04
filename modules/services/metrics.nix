{
  config,
  storageLocation,
  pkgs,
  ...
}: {
  age.secrets = {
    awsSecret = {
      file = ../../secrets/aws_ro_secret.age;
      owner = "grafana";
      mode = "600";
      group = "grafana";
    };
    vultrApiKey = {
      file = ../../secrets/vultr_api_key.age;
      owner = "grafana";
      mode = "600";
      group = "grafana";
    };
    awsAccess = {
      file = ../../secrets/aws_ro_access.age;
      owner = "grafana";
      mode = "600";
      group = "grafana";
    };

    nextCloudAccess = {
      file = ../../secrets/nextCloudMonitoringAccessToken.age;
      owner = "nextcloud-exporter";
      mode = "600";
      group = "nextcloud-exporter";
    };
  };

  environment.persistence.${storageLocation} = {
    # TODO: independent redis and rabbitmq with special volume
    directories = [
      {
        directory = "/var/lib/grafana";
        user = "grafana";
        group = "grafana";
        mode = "u=rwx,g=rx,o=";
      }
      {
        directory = "/var/lib/prometheus";
        user = "prometheus";
        group = "prometheus";
        mode = "u=rwx,g=rx,o=";
      }
    ];
  };

  services = {
    grafana = {
      enable = true;

      declarativePlugins = with pkgs.grafanaPlugins; [yesoreyeram-infinity-datasource];

      provision = {
        enable = true;

        datasources.settings = {
          deleteDatasources = [
            {
              name = "Vultr Client";
              orgId = 1;
            }
          ];

          datasources = [
            {
              name = "Vultr HTTP client";
              type = "yesoreyeram-infinity-datasource";
              url = "https://api.vultr.com/";

              jsonData = {
                httpHeaderName1 = "Authorization";
                allowedHosts = ["https://api.vultr.com/"];
              };

              secureJsonData = {
                httpHeaderValue1 = "$__file{${config.age.secrets.vultrApiKey.path}}";
              };
            }
            {
              name = "Prometheus";
              type = "prometheus";
              url = "http://${config.services.prometheus.listenAddress}:${toString config.services.prometheus.port}";
            }

            {
              name = "CloudWatch";
              type = "cloudwatch";
              jsonData = {
                authType = "keys";
                defaultRegion = "ap-southeast-2";
              };
              secureJsonData = {
                accessKey = "$__file{${config.age.secrets.awsAccess.path}}";
                secretKey = "$__file{${config.age.secrets.awsSecret.path}}";
              };
            }
          ];
        };
      };

      settings = {
        server = {
          # Listening Address
          http_addr = "127.0.0.1";
          # and Port
          http_port = 3988;
          # Grafana needs to know on which domain and URL it's running
          domain = "metrics.vagahbond.com";
          #          serve_from_sub_path = true;
        };
      };
    };

    prometheus = {
      enable = true;
      globalConfig.scrape_interval = "10s"; # "1m"
      retentionTime = "31d";
      scrapeConfigs = [
        {
          job_name = "node";
          static_configs = [
            {
              targets = ["localhost:${toString config.services.prometheus.exporters.node.port}"];
            }
          ];
        }
        {
          job_name = "systemd";
          static_configs = [
            {
              targets = ["localhost:${toString config.services.prometheus.exporters.systemd.port}"];
            }
          ];
        }
        {
          job_name = "nginx";
          static_configs = [
            {
              targets = ["localhost:${toString config.services.prometheus.exporters.nginx.port}"];
            }
          ];
        }
        {
          job_name = "nextcloud";
          static_configs = [
            {
              targets = ["localhost:${toString config.services.prometheus.exporters.nextcloud.port}"];
            }
          ];
        }
      ];

      exporters = {
        nginx = {
          enable = true;
          port = 9896;
          sslVerify = false;
        };
        systemd = {
          enable = true;
          port = 9897;
        };

        node = {
          enable = true;
          port = 9898;
          # https://github.com/NixOS/nixpkgs/blob/nixos-24.05/nixos/modules/services/monitoring/prometheus/exporters.nix
          enabledCollectors = ["systemd"];
          # /nix/store/zgsw0yx18v10xa58psanfabmg95nl2bb-node_exporter-1.8.1/bin/node_exporter  --help
          extraFlags = ["--collector.ethtool" "--collector.softirqs" "--collector.tcpstat" "--collector.wifi"];
        };

        nextcloud = {
          enable = true;
          url = "https://${config.services.nextcloud.hostName}";
          tokenFile = "${config.age.secrets.nextCloudAccess.path}";
          # port = 1212;
        };
      };
    };

    nginx.virtualHosts."metrics.vagahbond.com" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:3988";
        proxyWebsockets = true; # needed if you need to use WebSocket
      };
    };
  };
}
