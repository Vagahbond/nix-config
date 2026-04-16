{
  targets = [
    "platypute"
  ];

  nixosConfiguration =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      ###################################################################
      # IMPERMANENCE                                                    #
      ###################################################################
      environment.persistence.${config.persistence.storageLocation} = {
        # TODO: independent redis and rabbitmq with special volume
        directories = [
          {
            directory = "/var/lib/ente";
            user = "ente";
            group = "ente";
            mode = "u=rwx,g=rx,o=";
          }
        ];
      };
      ###################################################
      # SECRETS                                         #
      ###################################################
      age.secrets = {
        enteS3Secret = {
          file = ../../secrets/ente_s3_secret.age;
          mode = "440";
          owner = "ente";
          group = "users";
        };
        enteEncKeySecret = {
          file = ../../secrets/ente_enc_key_secret.age;
          mode = "440";
          owner = "ente";
          group = "users";
        };
        enteEncHashSecret = {
          file = ../../secrets/ente_enc_hash_secret.age;
          mode = "440";
          owner = "ente";
          group = "users";
        };
        enteJWTSecret = {
          file = ../../secrets/ente_jwt_secret.age;
          mode = "440";
          owner = "ente";
          group = "users";
        };

        enteOTTSecret = {
          file = ../../secrets/ente_ott_secret.age;
          mode = "440";
          owner = "ente";
          group = "users";
        };
      };

      ###################################################
      # SSL                                             #
      ###################################################
      services.nginx.virtualHosts = {
        "pics.vagahbond.com" = {
          forceSSL = true;
          enableACME = true;
        };
        "api.pics.vagahbond.com" = {
          forceSSL = true;
          enableACME = true;
        };
        "accounts.pics.vagahbond.com" = {
          forceSSL = true;
          enableACME = true;
        };
        "cast.pics.vagahbond.com" = {
          forceSSL = true;
          enableACME = true;
        };
      };

      ###################################################
      # SERVICES                                        #
      ###################################################
      services = {
        ente = {
          web = {
            enable = true;
            package = pkgs.ente-web.overrideAttrs (
              _:
              let
                enteMainUrl = config.services.ente.web.domains.photos;
              in
              {
                postPatch = # Use our `wasm-pack` binary, rather than the Node version, which is
                  # just a wrapper that tries to download the actual binary
                  ''
                    substituteInPlace \
                      packages/wasm/package.json \
                      --replace-fail "wasm-pack " ${lib.escapeShellArg "${pkgs.wasm-pack}/bin/wasm-pack "}
                  ''
                  # Replace hardcoded ente.io urls if desired
                  + lib.optionalString (enteMainUrl != null) ''
                    substituteInPlace \
                      apps/payments/src/services/billing.ts \
                      apps/photos/src/pages/shared-albums.tsx \
                      --replace-fail "https://ente.io" ${lib.escapeShellArg enteMainUrl}

                    substituteInPlace \
                      apps/accounts/src/pages/index.tsx \
                      --replace-fail "https://web.ente.io" ${lib.escapeShellArg enteMainUrl}
                  '';
              }
            );
            domains = {
              photos = "pics.vagahbond.com";
              api = "api.pics.vagahbond.com";
              albums = "albums.pics.vagahbond.com";
              accounts = "accounts.pics.vagahbond.com";
              cast = "cast.pics.vagahbond.com";
            };
          };
          api = {
            enable = true;
            nginx.enable = true;
            enableLocalDB = true;
            domain = "api.pics.vagahbond.com";
            settings = {
              db = {
                user = "ente";
                name = "ente";
              };
              s3 = {
                are_local_buckets = false;
                use_path_style_urls = false;
                b2-eu-cen = {
                  are_local_buckets = false;
                  use_path_style_urls = false;
                  key = "AKIAZI2LIHXHDKAQN73F";
                  # TODO: own secret
                  secret._secret = config.age.secrets.enteS3Secret.path;
                  # endpoint = "com.amazonaws.ap-southeast-2.s3";
                  region = "ap-southeast-2";
                  bucket = "vagahbond-ente-s3";
                };
              };
              key = {
                encryption._secret = config.age.secrets.enteEncKeySecret.path;
                hash._secret = config.age.secrets.enteEncHashSecret.path;
              };
              # JWT secrets
              jwt = {
                secret._secret = config.age.secrets.enteJWTSecret.path;
              };
              internal = {
                admin = "1580559962386438";
                hardcoded-ott = {
                  emails = [
                  ];
                  code._secret = config.age.secrets.enteOTTSecret.path;
                };
              };
            };
          };
        };
      };
    };
}
