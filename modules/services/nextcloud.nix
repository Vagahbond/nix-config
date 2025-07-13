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

  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    enableACME = true;
    locations = {
      "/".proxyWebsockets = true;
      # uh, equals what?
      # "~ ^\/nextcloud\/(?:index|remote|public|cron|core\/ajax\/update|status|ocs\/v[12]|updater\/.+|oc[ms]-provider\/.+|.+\/richdocumentscode\/proxy)\.php(?:$|\/)" = {};
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
        };
      };
    };

    nextcloud = {
      enable = true;
      # home = "/var/lib/nextcloud";
      package = pkgs.nextcloud31;
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

      extraApps = {
        inherit (config.services.nextcloud.package.packages.apps) contacts calendar notes news memories recognize richdocuments;
        tasks = pkgs.fetchNextcloudApp {
          appName = "tasks";
          sha256 = "0v1yzaa41zglafvyfny82hab78sbbv69bjx5vhavbxwvbxvbg5jj";
          url = "https://github.com/nextcloud/tasks/releases/download/v0.16.1/tasks.tar.gz";
          appVersion = "0.16.1";
          license = "agpl3Plus";
        };
        cospend = pkgs.fetchNextcloudApp {
          appName = "cospend";
          sha256 = "1zqyylw7l3bd3wkb1i0qpaccfp3hwb7ynnfii4qw9llr32bydxmd";
          url = "https://github.com/julien-nc/cospend-nc/releases/download/v3.0.11/cospend-3.0.11.tar.gz";
          appVersion = "3.0.11";
          license = "agpl3Plus";
        };
        maps = pkgs.fetchNextcloudApp {
          appName = "maps";
          sha256 = "sha256-E0S/CwXyye19lcuiONEQCyHJqlL0ZG1A9Q7oOTEZH1g=";
          url = "https://github.com/nextcloud/maps/releases/download/v1.6.0-3-nightly/maps-1.6.0-3-nightly.tar.gz";

          appVersion = "1.6.0";
          license = "agpl3Plus";
        };
        user_usage_report = pkgs.fetchNextcloudApp {
          appName = "user_usage_report";
          sha256 = "sha256-itWaJUHnBZmsBrL4O0fps/DgSm7MEt0JeIrNM1LlRUk=";
          url = "https://github.com/nextcloud-releases/user_usage_report/releases/download/v2.0.0/user_usage_report-v2.0.0.tar.gz";

          appVersion = "25.4.202";
          license = "agpl3Plus";
        };
        forms = pkgs.fetchNextcloudApp {
          appName = "forms";
          sha256 = "1rhgxyw46f529n8ixrig4rnpig9z75mp5jvwwfh7ym3xmx3gb3xp";
          url = "https://github.com/nextcloud-releases/forms/releases/download/v5.1.0/forms-v5.1.0.tar.gz";
          appVersion = "5.1.0";
          license = "agpl3Plus";
        };
      };
      extraAppsEnable = true;
    };
  };
}
