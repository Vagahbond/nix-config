{
  targets = [
    "platypute"
  ];

  nixosConfiguration =
    { config, ... }:
    {

      ###################################################
      # SECRETS                                         #
      ###################################################

      age.secrets = {
        fireflyKey = {
          file = ../../secrets/firefly_app_key.age;
          mode = "440";
          owner = config.services.firefly-iii.user;
          group = config.services.firefly-iii.group;
        };
      };

      ###################################################
      # IMPERMANENCE                                    #
      ###################################################
      environment.persistence.${config.persistence.storageLocation} = {
        directories = [
          {
            directory = config.services.firefly-iii.dataDir;
            inherit (config.services.firefly-iii) user group;
            mode = "u=rwx,g=rx,o=";
          }
          {
            directory = config.services.firefly-iii-data-importer.dataDir;
            inherit (config.services.firefly-iii-data-importer) user group;
            mode = "u=rwx,g=rx,o=";
          }
        ];
      };

      systemd.services.firefly-iii-setup = {
        serviceConfig.StateDirectory = [
          "firefly-iii/storage/app/public"
          "firefly-iii/storage/logs"
          "firefly-iii/storage/framework/cache"
          "firefly-iii/storage/framework/sessions"
          "firefly-iii/storage/framework/views"
        ];
      };

      ###################################################
      # SERVICES                                        #
      ###################################################

      services = {
        firefly-iii = {
          enable = true;
          virtualHost = "money.vagahbond.com";
          enableNginx = true;

          settings = {
            APP_ENV = "production";
            DB_CONNECTION = "pgsql";
            APP_KEY_FILE = config.age.secrets.fireflyKey.path;
            DB_DATABASE = config.services.firefly-iii.user;
            DB_USERNAME = config.services.firefly-iii.user;
          };
        };
        firefly-iii-data-importer = {
          enable = true;
          virtualHost = "importer.money.vagahbond.com";
          enableNginx = true;
        };
      };

      ###################################################
      # SSL                                             #
      ###################################################
      services.nginx.virtualHosts = {
        ${config.services.firefly-iii.virtualHost} = {
          forceSSL = true;
          enableACME = true;
        };

        ${config.services.firefly-iii-data-importer.virtualHost} = {
          forceSSL = true;
          enableACME = true;
        };
      };
    };
}
