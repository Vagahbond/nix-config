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
            directory = config.services.firefly-iii.settings.dataDir;
            inherit (config.services.firefly-iii) user group;
            mode = "u=rwx,g=rx,o=";
          }
          {
            directory = config.services.firefly-iii-importer.settings.dataDir;
            inherit (config.services.firefly-iii-importer) user group;
            mode = "u=rwx,g=rx,o=";
          }
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
            port = 3054;
            hostname = "localhost";
            DB_CONNECTION = "pgsql";
            APP_KEY_FILE = config.age.secrets.fireflyKey.path;
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

        ${config.services.firefly-iii-importer.virtualHost} = {
          forceSSL = true;
          enableACME = true;
        };
      };
    };
}
