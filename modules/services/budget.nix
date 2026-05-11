{
  targets = [
    "platypute"
  ];

  nixosConfiguration =
    { config, inputs, ... }:
    {

      imports = [
        inputs.firesplit.nixosModules.default
      ];

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
      # environment.persistence.${config.persistence.storageLocation} = {
      #   directories = [
      #     {
      #       directory = config.services.firefly-iii.dataDir;
      #       inherit (config.services.firefly-iii) user group;
      #       mode = "u=rwx,g=rx,o=";
      #     }
      #     {
      #       directory = config.services.firefly-iii-data-importer.dataDir;
      #       inherit (config.services.firefly-iii-data-importer) user group;
      #       mode = "u=rwx,g=rx,o=";
      #     }
      #   ];
      # };
      #
      systemd.services.firefly-iii-setup = {
        serviceConfig.StateDirectory = [
          "firefly-iii/storage/app/public"
          "firefly-iii/storage/logs"
          "firefly-iii/storage/framework/cache"
          "firefly-iii/storage/framework/sessions"
          "firefly-iii/storage/framework/views"
          "firefly-iii/storage/cache"

        ];
      };

      systemd.services.firefly-iii-data-importer-setup = {
        serviceConfig.StateDirectory = [
          "firefly-iii-data-importer/storage/app/public"
          "firefly-iii-data-importer/storage/logs"
          "firefly-iii-data-importer/storage/uploads"
          "firefly-iii-data-importer/storage/import-jobs"
          "firefly-iii-data-importer/storage/framework/cache"
          "firefly-iii-data-importer/storage/framework/sessions"
          "firefly-iii-data-importer/storage/framework/views"
          "firefly-iii-data-importer/cache"
        ];
      };

      ###################################################
      # SERVICES                                        #
      ###################################################

      services = {
        firefly-iii = {
          enable = true;
          virtualHost = "money.vagahbond.com";
          # enableNginx = true;

          settings = {
            APP_ENV = "production";
            DB_CONNECTION = "pgsql";
            APP_KEY_FILE = config.age.secrets.fireflyKey.path;
            DB_DATABASE = config.services.firefly-iii.user;
            DB_USERNAME = config.services.firefly-iii.user;
          };

          firesplit = {
            enable = true;
            port = 3004;
          };
        };

        firefly-iii-data-importer = {
          enable = true;
          virtualHost = "importer.money.vagahbond.com";
          enableNginx = true;
        };

        postgresql = {

          ensureDatabases = [ config.services.firefly-iii.user ];
          ensureUsers = [
            {
              name = config.services.firefly-iii.user;
              ensureDBOwnership = true;
            }
          ];
        };
      };

      ###################################################
      # SSL                                             #
      ###################################################
      services.nginx.virtualHosts = {
        ${config.services.firefly-iii.virtualHost} = {
          locations = {
            "/debts" = {
              proxyPass = "http://127.0.0.1:3004";
              proxyWebsockets = true; # needed if you need to use WebSocket
            };

            "~ \\.php$" = {
              extraConfig = ''
                include ${config.services.nginx.package}/conf/fastcgi_params ;
                fastcgi_param SCRIPT_FILENAME $request_filename;
                fastcgi_param modHeadersAvailable true; #Avoid sending the security headers twice
                fastcgi_pass unix:${config.services.phpfpm.pools.firefly-iii.socket};
              '';
            };

            "/" = {
              tryFiles = "$uri $uri/ /index.php?$query_string";
              index = "index.php";
              extraConfig = ''
                sendfile off;
              '';
            };
          };
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
