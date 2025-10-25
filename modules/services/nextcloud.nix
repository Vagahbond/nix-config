{
  config,
  storageLocation,
  pkgs,
}: {
  ###################################################
  # PORTS                                           #
  ###################################################
  #  networking.firewall.allowedTCPPorts = [8000];

  ###################################################################
  # IMPERMANENCE                                                    #
  ###################################################################
  environment.persistence.${storageLocation} = {
    # TODO: independent redis and rabbitmq with special volume
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

  age.secrets.nextcloudS3Secret = {
    file = ../../secrets/nextcloud_s3_secret.age;
    mode = "440";
    owner = "nextcloud";
    group = "users";
  };
  ###################################################
  # SSL                                             #
  ###################################################

  services.nginx.virtualHosts = {
    ${config.services.nextcloud.hostName} = {
      forceSSL = true;
      enableACME = true;
      locations = {
        "/".proxyWebsockets = true;
        # uh, equals what?
        # "~ ^\/nextcloud\/(?:index|remote|public|cron|core\/ajax\/update|status|ocs\/v[12]|updater\/.+|oc[ms]-provider\/.+|.+\/richdocumentscode\/proxy)\.php(?:$|\/)" = {};
      };
    };
    localhost = {
      locations = {
        "/nextcloud-users-usage-report/" = {
          root = "/var/lib/nextcloud";
          index = "report.csv";
        };
      };
    };
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
          unixSocketPerm = 770;
          unixSocket = "/run/redis-nextcloud/redis.sock";
        };
      };
    };

    nextcloud = {
      enable = true;
      # home = "/var/lib/nextcloud";
      package = pkgs.nextcloud32;
      hostName = "nuage.vagahbond.com";
      https = true;
      maxUploadSize = "4G";
      config = {
        dbtype = "pgsql";
        adminpassFile = config.age.secrets.nextcloudAdminPass.path;
        objectstore.s3 = {
          enable = true;
          verify_bucket_exists = false;
          bucket = "vagahbond-nextcloud-s3";
          key = "AKIAZI2LIHXHGU2IFURD";
          secretFile = config.age.secrets.nextcloudS3Secret.path;
          region = "ap-southeast-2";
        };
      };
      settings = {
        # trusted_proxies = ["192.168.0.3"];
        default_phone_region = "FR";
        redis = {
          host = "/run/redis-nextcloud/redis.sock";
          dbindex = 0;
          timeout = 1.5;
        };
        maintenance_window_start = 1;
      };
      phpOptions = {
        output_buffering = "off";
        "opcache.interned_strings_buffer" = "23";
      };
      phpExtraExtensions = all: [
        all.redis
      ];
      caching = {
        redis = true;
        memcached = true;
      };
      database = {
        createLocally = true;
      };

      extraApps = {
        inherit (config.services.nextcloud.package.packages.apps) contacts calendar notes news memories recognize richdocuments;
        tasks = pkgs.fetchNextcloudApp {
          appName = "tasks";
          sha256 = "0a1x9b3sf1w0f5y3vcg0vc8srvbma8iyrh35anpy50pk3p2vsyw7";
          url = "https://github.com/nextcloud/tasks/releases/download/v0.17.0/tasks.tar.gz";
          appVersion = "0.17.0";
          license = "agpl3Plus";
        };
        cospend = pkgs.fetchNextcloudApp {
          appName = "cospend";
          sha256 = "0xsq3vn5hvf3kz4qwm178qwvzvvwb6rp02c8kvmh64m4lvmaag98";
          url = "https://github.com/julien-nc/cospend-nc/releases/download/v3.1.6/cospend-3.1.6.tar.gz";
          appVersion = "3.1.6";
          license = "agpl3Plus";
        };
        /*
           maps = pkgs.fetchNextcloudApp {
          appName = "maps";
          sha256 = "1pbl3yf6j0gajxsrw0k6y0si5q9isf2cxbabi59rxxzcd3553si2";
          url = "https://github.com/nextcloud/maps/releases/download/v1.6.0/maps-1.6.0.tar.gz";

          appVersion = "1.6.0";
          license = "agpl3Plus";
        };
        */
        user_usage_report = pkgs.fetchNextcloudApp {
          appName = "user_usage_report";
          sha256 = "1sywb17k05qjmqpr0qrb1j6hpi5wlpnybicn3i50zmxi1yri7hjl";
          url = "https://github.com/nextcloud-releases/user_usage_report/releases/download/v3.0.0/user_usage_report-v3.0.0.tar.gz";

          appVersion = "3.0.0";
          license = "agpl3Plus";
        };
      };
      extraAppsEnable = true;
    };
  };

  systemd = {
    services.nextcloud-usage-report = {
      unitConfig = {
        Description = "Generate a report of usage per users";
      };

      serviceConfig = {
        Type = "oneshot";
        ExecStartPre = pkgs.writeShellScript "nextcloud-users-usage-report-prepare.sh" ''
          mkdir -p /var/lib/nextcloud/nextcloud-users-usage-report;
          chown nextcloud:nextcloud /var/lib/nextcloud/nextcloud-users-usage-report;
          rm -rf /var/lib/nextcloud/nextcloud-users-usage-report/* ;
        '';

        ExecStart = ''
          /run/current-system/sw/bin/nextcloud-occ usage-report:generate --output csv -O /var/lib/nextcloud/nextcloud-users-usage-report/report.csv
        '';
        ExecStartPost = pkgs.writeShellScript "nextcloud-users-usage-report-finish.sh" ''
          chown -R nginx:nginx /var/lib/nextcloud/nextcloud-users-usage-report;
        '';

        TimeoutStopSec = "600";
        KillMode = "process";
        KillSignal = "SIGINT";
        # RemainAfterExit = true;
      };
      wantedBy = ["multi-user.target"];
      after = ["nextcloud-setup.service"];
    };
    timers.nextcloud-usage-report = {
      description = "Timer for user reports on NC";
      timerConfig = {
        OnBootSec = "15s";
        OnUnitActiveSec = "10m";
      };
      wantedBy = ["multi-user.target" "timers.target"];
    };
    # startServices = true;
  };
}
