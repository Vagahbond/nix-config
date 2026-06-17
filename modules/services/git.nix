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

              service = {
                DISABLE_REGISTRATION = true;
              };

              session = {
                COOKIE_SECURE = true;
              };
            };
          };
        };

        systemd.services.forgejo.preStart =
          let
            adminCmd = "${lib.getExe config.services.forgejo.package} admin user";
            pwd = config.sops.secrets.forgejo-admin-password;
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
