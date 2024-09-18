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
          sha256 = "sha256-HitYQcdURUHujRNMF0jKQzvSO93bItisI0emq0yw8p4=";
          url = "https://github.com/nextcloud/tasks/releases/download/v0.16.0/tasks.tar.gz";
          appVersion = "0.16.0";
          license = "agpl3Plus";
        };
        cospend = pkgs.fetchNextcloudApp {
          appName = "cospend";
          sha256 = "sha256-J6w+ZqFNZbJeaPuZOZ4OQ+O+VhIQ0XajqYZuHqvjL24=";
          url = "https://github.com/julien-nc/cospend-nc/releases/download/v1.6.1/cospend-1.6.1.tar.gz";
          appVersion = "9.0.2";
          license = "agpl3Plus";
        };
        deck = pkgs.fetchNextcloudApp {
          appName = "deck";
          sha256 = "sha256-/5/NNkuBEtXAHsDkaA/PHZCBLSl5U1e/rV4nU/Ir7TI=";
          url = "https://github.com/nextcloud/deck/releases/download/v1.13.0/deck.tar.gz";
          appVersion = "1.13.0";
          license = "agpl3Plus";
        };
        quicknotes = pkgs.fetchNextcloudApp {
          appName = "quicknotes";
          sha256 = "sha256-8ppIN7ITiQVsgPzbRVB6OHe4vSzdBBovHexBkr4yffY=";
          url = "https://github.com/matiasdelellis/quicknotes/releases/download/v0.8.23/quicknotes.tar.gz";
          appVersion = "0.8.23";
          license = "agpl3Plus";
        };
        forms = pkgs.fetchNextcloudApp {
          appName = "forms";
          sha256 = "sha256-OqqorHVWCDicQKnTxEJjeXzDrsj98vWvtWYyaRmDsUs=";
          url = "https://github.com/nextcloud-releases/forms/releases/download/v4.2.4/forms-v4.2.4.tar.gz";
          appVersion = "4.2.4";
          license = "agpl3Plus";
        };
      };
      extraAppsEnable = true;
    };
  };
}
