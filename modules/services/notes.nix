{
  storageLocation,
  inputs,
  config,
  pkgs,
  ...
}: {
  ###################################################################
  # USERS                                                           #
  ###################################################################
  users.groups.affine = {};

  users.users.affine = {
    isNormalUser = true;
    # isSystemUser = true;
    group = "affine";
    # extraGroups = ["wheel"];
    createHome = true;
  };

  ###################################################################
  # DATABASE                                                        #
  ###################################################################

  services.postgresql = {
    ensureUsers = [
      {
        name = "affine";
        ensureDBOwnership = true;
        ensureClauses.login = true;
      }
    ];
    ensureDatabases = ["affine"];
  };

  ###################################################################
  # SECRETS                                                         #
  ###################################################################
  age.secrets.affineEnv = {
    file = ../../secrets/affine_env.age;
    mode = "440";
    owner = "affine";
    group = "affine";
  };

  ###################################################################
  # SERVICE                                                         #
  ###################################################################
  virtualisation.oci-containers.containers = {
    affine = {
      autoStart = true;
      image = "ghcr.io/toeverything/affine:stable";
      dependsOn = [];
      user = "affine:affine";
      podman.user = "affine";

      environmentFiles = [
        config.age.secrets.affineEnv.path
      ];

      environment = {
        AFFINE_REVISION = "stable";
        PORT = "3010";
        AFFINE_SERVER_HTTPS = "false";
        AFFINE_SERVER_EXTERNAL_URL = "https://notes.vagahbond.com";
        AFFINE_SERVER_HOST = "notes.vagahbond.com";

        # it uses the 4 next databases for some reason...
        REDIS_SERVER_DATABASE = "0";
        REDIS_SERVER_HOST = "/run/redis-default/redis.sock";

        DB_USERNAME = "affine";
        DB_DATABASE = "affine";

        AFFINE_INDEXER_ENABLED = "false";
      };

      volumes = [
        "affine-storage:/root/.affine/storage"
        "affine-config:/root/.affine/config"
      ];

      hostname = "affine";
      ports = ["8086:3010"];
    };
  };

  ###################################################################
  # CACHING                                                         #
  ###################################################################
  services = {
    redis = {
      servers = {
        affine = {
          enable = true;
          user = "affine";
          port = 0;
        };
      };
    };
  };

  ###################################################################
  # PROXY                                                           #
  ###################################################################
  services.nginx.virtualHosts."notes.vagahbond.com" = {
    forceSSL = true;
    enableACME = true;
    # basicAuthFile = config.age.secrets.silverbulletEnv.path;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8086";
      proxyWebsockets = true; # needed if you need to use WebSocket
    };
  };
}
