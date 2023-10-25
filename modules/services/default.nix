{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  username = import ../../username.nix;
  hostname = config.networking.hostName;
  inherit (config.modules.impermanence) storageLocation;
  cfg = config.modules.services;
in {
  imports = [./options.nix];

  config = mkMerge [
    (
      mkIf cfg.ssh.enable {
        age.secrets."${hostname}_access" = {
          file = ../../secrets/${hostname}_access.age;
          path = "${config.users.users.${username}.home}/.ssh/authorized_keys";
          mode = "600";
          owner = username;
          group = "users";
        };

        services.openssh = {
          enable = true;
          settings = {
            PasswordAuthentication = false;
          };
          banner = ''
             ██████╗████████╗███████╗ ██████╗
            ██╔════╝╚══██╔══╝██╔════╝██╔═══██╗
            ██║  ███╗  ██║   █████╗  ██║   ██║
            ██║   ██║  ██║   ██╔══╝  ██║   ██║
            ╚██████╔╝  ██║   ██║     ╚██████╔╝
             ╚═════╝   ╚═╝   ╚═╝      ╚═════╝


            This is a private system. Unauthorized access is prohibited.
            All actions will be logged.
            Seriously get the fuck out.
          '';
        };
      }
    )
    (
      mkIf cfg.postgres.enable {
        services.postgresql = {
          enable = true;
          package = pkgs.postgresql;
          dataDir = "/nix/postgresql";

          enableTCPIP = false;

          checkConfig = true;
          settings = {
            log_connections = true;
            log_statement = "all";
            logging_collector = true;
            log_disconnections = true;
            log_destination = lib.mkForce "syslog";
          };
          ensureUsers = [
            {
              name = "postgres";
              ensurePermissions."ALL TABLES IN SCHEMA public" = "ALL PRIVILEGES";
            }
          ];
        };
      }
    )

    (
      mkIf cfg.nextcloud.enable {
        networking.firewall.allowedTCPPorts = [80 8000];

        environment.persistence.${storageLocation} = {
          directories = [
            {
              directory = "/var/lib/nextcloud";
              user = "nextcloud";
              group = "nextcloud";
              mode = "u=rwx,g=rx,o=";
            }
            {
              directory = "/var/lib/redis-nextcloud";
              user = "nextcloud";
              group = "nextcloud";
              mode = "u=rwx,g=rx,o=";
            }
            {
              directory = "/var/lib/onlyoffice";
              user = "onlyoffice";
              group = "onlyoffice";
              mode = "u=rwx,g=rx,o=";
            }
            {
              directory = "/var/lib/postgresql";
              user = "postgres";
              group = "postgres";
              mode = "u=rwx,g=rx,o=";
            }
            {
              directory = "/var/lib/rabbitmq";
              user = "rabbitmq";
              group = "rabbitmq";
              mode = "u=rwx,g=rx,o=";
            }
          ];
        };
        age.secrets.nextcloudAdminPass = {
          file = ../../secrets/nextcloud_admin_pass.age;
          mode = "440";
          owner = "nextcloud";
          group = "users";
        };

        services = {
          redis = {
            servers = {
              nextcloud = {
                enable = true;
                user = "nextcloud";
                port = 0;
              };
            };
          };

          nginx = {
            recommendedTlsSettings = true;
            recommendedOptimisation = true;
            recommendedGzipSettings = true;
            recommendedProxySettings = true;
          };

          onlyoffice = {
            enable = true;
            hostname = "office.vagahbond.com";
          };

          nextcloud = {
            enable = true;
            package = pkgs.nextcloud27;
            hostName = "cloud.vagahbond.com";
            https = true;
            maxUploadSize = "4G";
            config = {
              dbtype = "pgsql";
              trustedProxies = ["192.168.0.3"];
              adminpassFile = config.age.secrets.nextcloudAdminPass.path;
              defaultPhoneRegion = "FR";
              # objectstore.s3.sseCKeyFile = "some file generated with openssl rand 32"
            };
            extraOptions = {
              redis = {
                host = "/run/redis-default/redis.sock";
                dbindex = 0;
                timeout = 1.5;
              };
            };
            caching = {
              redis = true;
            };
            database = {
              createLocally = true;
            };

            extraApps = with config.services.nextcloud.package.packages.apps; {
              inherit files_markdown contacts calendar tasks onlyoffice;
            };
            extraAppsEnable = true;
          };
        };
      }
    )
  ];
}
