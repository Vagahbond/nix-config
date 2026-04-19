{

  targets = [ "platypute" ];
  nixosConfiguration =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {

      ###################################################
      # SECRETS                                         #
      ###################################################

      age.secrets = {
        n8nEncryptionKey = {
          file = ../../secrets/n8n_encryption_key.age;
          mode = "440";
          owner = "n8n";
          group = "n8n";
        };

        n8nRunnersAuthToken = {
          file = ../../secrets/n8n_runners_auth_token.age;
          mode = "440";
          owner = "n8n";
          group = "n8n";
        };
      };

      ###################################################
      # IMPERMANENCE                                    #
      ###################################################
      # environment.persistence.${config.persistence.storageLocation} = {
      #   directories = [
      #     {
      #       directory = "/var/lib/n8n";
      #       user = "n8n";
      #       group = "n8n";
      #       mode = "u=rwx,g=rx,o=";
      #     }
      #   ];
      # };

      ###################################################
      # SERVICES                                        #
      ###################################################

      users.users.n8n = {
        isSystemUser = true;
        group = "n8n";
      };

      users.groups.n8n = { };

      systemd.services.n8n.serviceConfig = {
        DynamicUser = pkgs.lib.mkForce false;
        User = "n8n";
      };

      services.n8n = {
        enable = true;

        package = pkgs.n8n.overrideAttrs (_: {
          NODE_OPTIONS = "--max-old-space-size=4096";
        });

        taskRunners = {
          enable = true;

          runners = {
            javascript = {
              enable = true;
              command = lib.getExe' config.services.n8n.package "n8n-task-runner";
              healthCheckPort = 5681;
            };
          };

          environment = {
            N8N_RUNNERS_AUTH_TOKEN_FILE = config.age.secrets.n8nRunnersAuthToken.path;
          };
        };
        environment = {
          N8N_ENCRYPTION_KEY_FILE = config.age.secrets.n8nEncryptionKey.path;
          N8N_RUNNERS_AUTH_TOKEN_FILE = config.age.secrets.n8nRunnersAuthToken.path;
          N8N_PORT = "5778";
          # N8N_USER_FOLDER = "/var/lib/n8n";
        };
      };

      ###################################################
      # PROXY                                           #
      ###################################################

      services.nginx.virtualHosts = {
        "automation.vagahbond.com" = {
          forceSSL = true;
          enableACME = true;

          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:${toString config.services.n8n.environment.N8N_PORT}";
              proxyWebsockets = true; # needed if you need to use WebSocket
            };
          };
        };
      };
    };
}
