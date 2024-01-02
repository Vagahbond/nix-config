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
      mkIf cfg.builder.enable {
        # age.secrets."builder_access" = {
        #   file = ../../secrets/builder_access.age;
        #   path = "${config.users.users.${username}.home}/.ssh/authorized_keys";
        #   mode = "600";
        #   owner = username;
        #   group = "users";
        # };

        users.groups.builder = {};
        users.users.builder = {
          isNormalUser = false;
          isSystemUser = true;
          group = "builder";
          extraGroups = ["wheel"];
          home = "/home/builder";
          description = "This user is gonna be used especially for the remote building for security reasons";
        };
      }
    )
    (
      mkIf cfg.postgres.enable {
        services.postgresql = {
          enable = true;
          package = pkgs.postgresql_14;
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
      mkIf cfg.vaultwarden.enable {
        ###################################################
        # PORTS                                           #
        ###################################################
        networking.firewall.allowedTCPPorts = [7060 3812];

        ###################################################
        # IMPERMANENCE                                    #
        ###################################################
        environment.persistence.${storageLocation} = {
          directories = [
            {
              directory = "/var/lib/bitwarden_rs";
              user = "vaultwarden";
              group = "vaultwarden";
              mode = "u=rwx,g=rx,o=";
            }
          ];
        };

        ###################################################
        # SERVICES                                        #
        ###################################################

        services.vaultwarden = {
          enable = true;
          backupDir = "/var/lib/bitwarden_rs/backup";
          # environmentFile =
          config = {
            ROCKET_ADDRESS = "0.0.0.0";
            ROCKET_PORT = 7060;
            DOMAIN = "https://pass.vagahbond.com";
            ROCKET_LOG = "critical";
          };
        };
      }
    )
    (
      mkIf cfg.nextcloud.enable {
        ###################################################
        # PORTS                                           #
        ###################################################
        networking.firewall.allowedTCPPorts = [80 8000];

        ###################################################
        # IMPERMANENCE                                    #
        ###################################################
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
            # {
            #   directory = "/var/lib/onlyoffice";
            #   user = "onlyoffice";
            #   group = "onlyoffice";
            #  mode = "u=rwx,g=rx,o=";
            # }
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

        ###################################################
        # SECRETS                                         #
        ###################################################
        age.secrets.nextcloudAdminPass = {
          file = ../../secrets/nextcloud_admin_pass.age;
          mode = "440";
          owner = "nextcloud";
          group = "users";
        };

        ###################################################
        # SERVICES                                        #
        ###################################################

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

          nextcloud = {
            enable = true;
            package = pkgs.nextcloud28;
            hostName = "cloud.vagahbond.com";
            https = true;
            maxUploadSize = "4G";
            config = {
              dbtype = "pgsql";
              adminpassFile = config.age.secrets.nextcloudAdminPass.path;
              # objectstore.s3.sseCKeyFile = "some file generated with openssl rand 32"
            };
            extraOptions = {
              trusted_proxies = ["192.168.0.3"];
              default_phone_region = "FR";
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
              inherit contacts calendar tasks notes;
            };
            extraAppsEnable = true;
          };
        };
      }
    )
    (
      mkIf (cfg.nextcloud.enable && cfg.nextcloud.backup) {
        ###################################################
        # BACKUP (WIP)                                    #
        ###################################################
        systemd = {
          services.nextcloud-backup = {
            unitConfig = {
              Description = "Auto backup Nextcloud";
            };
            serviceConfig = {
              Type = "oneshot";
              ExecStartPre = ''
                sudo -u nextcloud ${config.services.nextcloud.package}/bin/nextcloud-occ maintenance:mode --on
              '';
              ExecStart = ''
                rsync -Aavx /var/lib/nextcloud /nix/persistent/nextcloud_backup_`date +"%Y%m%d"`/ > /nix/persistent/nextcloud-backup.logs
                sudo -u postgres pg_dump nextcloud  -U postgres -f nextcloud-sqlbkp_`date +"%Y%m%d"`.bak
              '';
              ExecPost = ''
                sudo -u nextcloud ${config.services.nextcloud.package}/bin/nextcloud-occ maintenance:mode --off
                sudo -u postgres pg_dump nextcloud  -U postgres -f /nix/persistent/nextcloud-sqlbkp_`date +"%Y%m%d"`.bak
              '';
              TimeoutStopSec = "600";
              KillMode = "process";
              KillSignal = "SIGINT";
              # RemainAfterExit = true;
            };
            WantedBy = ["multi-user.target"];
          };
          timers.nextcloud-backup = {
            description = "Automatic files backup for Nextcloud when booted up after 2 minutes then rerun every 30 minutes";
            timerConfig = {
              onCalendar = "weekly";
            };
            wantedBy = ["multi-user.target" "timers.target"];
          };
          # startServices = true;
        };
      }
    )
  ];
}
