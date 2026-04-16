{

  targets = [ "platypute" ];
  nixosConfiguration =
    { config, lib, ... }:
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
      environment.persistence.${config.persistence.storageLocation} = {
        directories = [
          {
            directory = config.services.n8n.environment.N8N_USER_FOLDER;
            user = "n8n";
            group = "n8n";
            mode = "u=rwx,g=rx,o=";
          }
        ];
      };

      ###################################################
      # SERVICES                                        #
      ###################################################
      services.n8n = {
        enable = false;
        taskRunners = {
          enable = false;

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
        };
      };

      ###################################################
      # PROXY                                           #
      ###################################################

      services.nginx.virtualHosts = {
        "automation.vagahbond.com" = {
          forceSSL = true;
          enableACME = true;
        };
      };
    };
}
