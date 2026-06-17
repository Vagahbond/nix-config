[
  {
    targets = [ "nixosConfiguration" ];
    conf =
      {
        pkgs,
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

        ###################################################
        # SERVICE                                         #
        ###################################################
        services.forgejo = {
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

        ###################################################
        # SSL                                             #
        ###################################################
        services.nginx.virtualHosts.${domain} = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString port}";
            proxyWebsockets = true;
          };
        };
      };
  }
]
