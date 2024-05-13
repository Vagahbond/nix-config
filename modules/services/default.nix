# https://blog.beardhatcode.be/2020/12/Declarative-Nixos-Containers.html
{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  username = import ../../username.nix;
  hostname = config.networking.hostName;

  keys = import ../../secrets/sshKeys.nix {inherit config lib;};
  inherit (config.modules.impermanence) storageLocation;
  cfg = config.modules.services;

  mkContainer = serviceName: serviceAddr: configCB: {
    containers.${serviceName} = let
      hostConfig = config;
    in {
      autoStart = true;
      ephemeral = true;
      privateNetwork = true;

      hostAddress = "192.168.100.1";
      localAddress = serviceAddr;
      #hostAddress6 = "fc00::1";
      #localAddress6 = "fc00::2";
      config = {
        config,
        pkgs,
        lib,
        ...
      }:
        lib.mkMerge [
          (configCB {inherit config pkgs lib hostConfig;})
          {
            system.stateVersion = "23.11";

            networking = {
              firewall = {
                enable = true;
              };
              # Use systemd-resolved inside the container
              # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
              useHostResolvConf = lib.mkForce false;
            };

            services.resolved.enable = true;
          }
        ];
    };
  };
in {
  imports = [./options.nix];

  config = mkMerge [
    (
      mkIf cfg.proxy.enable (
        let
          ip = "192.168.100.2";
        in
          {
            networking = {
              firewall.allowedTCPPorts = [80 443];
              nat.forwardPorts = [
                {
                  destination = "${ip}:80";
                  sourcePort = 80;
                }
                {
                  destination = "${ip}:443";
                  sourcePort = 443;
                }
              ];
            };
          }
          // (mkContainer "proxy"
            ip (import ./proxy.nix))
      )
    )
    (
      mkIf cfg.blog.enable {
        environment.persistence.${storageLocation} = {
          directories = [
            {
              directory = "/var/lib/writefreely";
              user = "writefreely";
              group = "writefreely";
              mode = "u=rwx,g=rx,o=";
            }
          ];
        };

        networking.firewall.allowedTCPPorts = [7090];

        services.writefreely = {
          # Create a WriteFreely instance.
          enable = true;

          # Create a WriteFreely admin account.
          admin = {
            name = "root";
          };

          settings = {
            #  server = {
            #    port = 7090;
            #  };

            app = {
              site_name = "Vagahbond tech blog";
              federation = true;
              site_description = "Le blog des maigres";
              min_username_len = 3;
              private = false;
              local_timeline = true;
              wf_modesty = true;
              landing = "/read";
              open_registration = false;
              user_invites = "admin";
            };
          };
          nginx = {
            # Enable Nginx and configure it to serve WriteFreely.
            enable = true;

            # You can force users to connect with HTTPS.
            forceSSL = false;
          };

          # The public host name to serve.
          host = "blog.yoni-firroloni.com";
        };
      }
    )
    (
      mkIf cfg.ssh.enable {
        users.users.${username}.openssh.authorizedKeys.keys = [
          keys."${hostname}_access".pub
        ];
        services = {
          fail2ban.enable = true;
          openssh = {
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
        };
      }
    )
    (
      mkIf cfg.homePage.enable (mkContainer "homepage" "192.168.100.3" (import ./website.nix))
    )
    (
      mkIf cfg.builder.enable {
        users.groups.builder = {};
        users.users.builder = {
          isNormalUser = true;
          # isSystemUser = true;
          group = "builder";
          extraGroups = ["wheel"];
          home = "/home/builder";
          description = "This user is gonna be used especially for the remote building for security reasons";
          openssh.authorizedKeys.keys = with keys; [
            builder_access.pub
          ];
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
        networking.firewall.allowedTCPPorts = [8000];

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
            hostName = "cloud.yoni-firroloni.com";
            https = true;
            maxUploadSize = "4G";
            config = {
              dbtype = "pgsql";
              adminpassFile = config.age.secrets.nextcloudAdminPass.path;
            };
            settings = {
              trusted_proxies = ["192.168.0.3"];
              default_phone_region = "FR";
              redis = {
                host = "/run/redis-default/redis.sock";
                dbindex = 0;
                timeout = 1.5;
              };
            };
            phpOptions = {
              output_buffering = "off";
            };
            caching = {
              redis = true;
            };
            database = {
              createLocally = true;
            };

            extraApps = with config.services.nextcloud.package.packages.apps; {
              inherit contacts calendar tasks notes maps;
              news = pkgs.fetchNextcloudApp {
                appName = "news";
                sha256 = "sha256-aePXUn57U+1e01dntxFuzWZ8ILzwbnsAOs60Yz/6zUU=";
                url = "https://github.com/nextcloud/news/releases/download/25.0.0-alpha4/news.tar.gz";
                appVersion = "25.0.0";
                license = "agpl3Plus";
              };
            };
            extraAppsEnable = true;
          };
        };
      }
    )
    # (
    #   mkIf (cfg.nextcloud.enable && cfg.nextcloud.backup) {
    #     ###################################################
    #     # BACKUP (WIP)                                    #
    #     ###################################################
    #     systemd = {
    #       services.nextcloud-backup = {
    #         unitConfig = {
    #           Description = "Auto backup Nextcloud";
    #         };
    #         serviceConfig = {
    #           Type = "oneshot";
    #           ExecStartPre = ''
    #             sudo -u nextcloud ${config.services.nextcloud.package}/bin/nextcloud-occ maintenance:mode --on
    #           '';
    #           ExecStart = ''
    #             rsync -Aavx /var/lib/nextcloud /nix/persistent/nextcloud_backup_`date +"%Y%m%d"`/ > /nix/persistent/nextcloud-backup.logs
    #             sudo -u postgres pg_dump nextcloud  -U postgres -f nextcloud-sqlbkp_`date +"%Y%m%d"`.bak
    #           '';
    #           ExecPost = ''
    #             sudo -u nextcloud ${config.services.nextcloud.package}/bin/nextcloud-occ maintenance:mode --off
    #             sudo -u postgres pg_dump nextcloud  -U postgres -f /nix/persistent/nextcloud-sqlbkp_`date +"%Y%m%d"`.bak
    #           '';
    #           TimeoutStopSec = "600";
    #           KillMode = "process";
    #           KillSignal = "SIGINT";
    #           # RemainAfterExit = true;
    #         };
    #         WantedBy = ["multi-user.target"];
    #       };
    #       timers.nextcloud-backup = {
    #         description = "Automatic files backup for Nextcloud when booted up after 2 minutes then rerun every 30 minutes";
    #         timerConfig = {
    #           onCalendar = "weekly";
    #         };
    #         wantedBy = ["multi-user.target" "timers.target"];
    #       };
    #       # startServices = true;
    #     };
    #   }
    # )
  ];
}
