[
  {
    targets = [ "nixosConfiguration" ];
    conf =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      let
        domain = "git.vagahbond.com";
        port = 3015;
      in
      {

        ###################################################
        # SECRETS                                         #
        ###################################################

        age.secrets.forgejoAdminPass = {
          file = ../../secrets/forgejo_admin_pass.age;
          owner = "forgejo";
          group = "forgejo";
          mode = "600";
        };

        ###################################################
        # PERSISTENCE                                     #
        ###################################################
        /*
          environment = {
            persistence.${config.persistence.storageLocation} = {
              directories = [
                {
                  directory = "/var/lib/forgejo";
                  user = "forgejo";
                  group = "forgejo";
                  mode = "u=rwx,g=rx,o=";
                }
              ];
            };
          };
        */

        ###################################################
        # SERVICE                                         #
        ###################################################
        services = {
          forgejo = {
            enable = true;

            database = {
              type = "postgres";
              createDatabase = true;
            };

            lfs.enable = true;

            settings = {
              server = {
                DOMAIN = domain;
                ROOT_URL = "https://${domain}/";
                HTTP_ADDR = "127.0.0.1";
                HTTP_PORT = port;
              };

              repository = {
                DISABLE_DOWNLOAD_SOURCE_ARCHIVES = true;
              };

              service = {
                DISABLE_REGISTRATION = true;
              };

              session = {
                COOKIE_SECURE = true;
              };
            };
          };

          # Will need isolated environment before I can kick it off.
          # Pondering between microVM and nixos-container.
          /*
            forgejo-runner.instances.nix = {
              instances.default = {
                enable = true;
                name = "monolith";
                url = config.services.forgejo.settings.server.ROOT_URL;
                labels = [
                  ## optionally provide native execution on the host:
                  "native:host"
                ];
              };
            };
          */
        };

        systemd.services.forgejo.preStart =
          let
            adminCmd = "${lib.getExe config.services.forgejo.package} admin user";
            pwd = config.age.secrets.forgejoAdminPass;
            user = "root"; # Note, Forgejo doesn't allow creation of an account named "admin"
          in
          ''
            ${adminCmd} create --admin --email "root@localhost" --username ${user} --password "$(tr -d '\n' < ${pwd.path})" || true
            ## uncomment this line to change an admin user which was already created
            # ${adminCmd} change-password --username ${user} --password "$(tr -d '\n' < ${pwd.path})" || true
          '';

        ###################################################
        # SSL                                             #
        ###################################################
        services.nginx.virtualHosts.${domain} = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString port}";
            proxyWebsockets = true;
            extraConfig = ''
              client_max_body_size 512M;
            '';
          };
        };
      };
  }
]
