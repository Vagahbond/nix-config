# TODO: Host Affine without container layer
[
  {
    targets = [ "nixosConfiguration" ];
    conf =
      { config, inputs, ... }:
      {

        imports = [
          inputs.affine-server.nixosModules.default
        ];

        ###################################################################
        # USERS                                                           #
        ###################################################################
        /*
          users.groups.affine = { };

          users.users.affine = {
            isNormalUser = true;
            # isSystemUser = true;
            group = "affine";
            # extraGroups = ["wheel"];
            createHome = true;
          };
        */

        ###################################################################
        # SECRETS                                                         #
        ###################################################################
        age.secrets.affineEnv = {
          file = ../../secrets/affine_env.age;
          mode = "440";
          owner = "root";
          group = "root";
        };

        age.secrets.affineKey = {
          file = ../../secrets/affine_key.age;
          mode = "400";
          owner = config.services.affine-server.user;
          group = config.services.affine-server.group;
        };

        ###################################################################
        # SERVICE                                                         #
        ###################################################################
        virtualisation.oci-containers.containers = {
          affine = {
            autoStart = true;
            entrypoint = "/bin/sh";
            cmd = [
              "-c"
              "node ./scripts/self-host-predeploy.js && node ./dist/main.js run"
            ];
            image = "ghcr.io/toeverything/affine:stable";

            environmentFiles = [
              config.age.secrets.affineEnv.path
            ];

            volumes = [
              "affine-storage:/root/.affine/storage"
              "affine-config:/root/.affine/config"
            ];

            hostname = "affine";
            ports = [ "8086:3010" ];
            dependsOn = [
              "affine-database"
              "affine-cache"
            ];
          };
          affine-database = {
            autoStart = true;
            image = "pgvector/pgvector:pg16";
            volumes = [
              "affine_db:/var/lib/postgresql/data"
            ];
            environmentFiles = [
              config.age.secrets.affineEnv.path
            ];
            hostname = "affine_database";
          };
          affine-cache = {
            autoStart = true;
            image = "redis:latest";
            hostname = "affine_redis";
          };
        };

        services.affine-server = {
          enable = true;

          database = {
            createLocally = true;
          };

          redis = {
            createLocally = true;
          };

          settings = {
            crypto = {
              privateKey._secret = config.age.secrets.affineKey.path;
            };
            server = {
              host = "beta.notes.vagahbond.com";

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
      };
  }
]
