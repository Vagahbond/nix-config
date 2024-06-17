{
  config,
  storageLocation,
  pkgs,
}: {
  ###################################################
  # PORTS                                           #
  ###################################################
  networking.firewall.allowedTCPPorts = [8000];

  ###################################################################
  # IMPERMANENCE                                                    #
  ###################################################################
  environment.persistence.${storageLocation} = {
    # TODO: independent redis and rabbitmq with special volume
    directories = [
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

  ###################################################
  # SSL                                             #
  ###################################################

  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    enableACME = true;
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
      home = "/data/nextcloud";
      package = pkgs.nextcloud29;
      hostName = "cloud.vagahbond.com";
      https = true;
      maxUploadSize = "4G";
      config = {
        dbtype = "pgsql";
        adminpassFile = config.age.secrets.nextcloudAdminPass.path;
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
        inherit (config.services.nextcloud.package.packages.apps) contacts calendar notes maps;
        tasks = pkgs.fetchNextcloudApp {
          appName = "tasks";
          sha256 = "sha256-L68ughpLad4cr5utOPwefu2yoOgRvnJibqfKmarGXLw=";
          url = "https://github.com/nextcloud/tasks/releases/download/v0.16.0/tasks.tar.gz";
          appVersion = "0.16.0";
          license = "agpl3Plus";
        };
      };
      extraAppsEnable = true;
    };
  };
}
