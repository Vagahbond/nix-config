[
  {
    targets = [ "nixosConfiguration" ];
    conf =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      let
        mainDomain = "pics.vagahbond.com";

        ente-web-albums = pkgs.ente-web.override {
          enteApp = "albums";
          enteMailUrl = "https://${mainDomain}";
          extraBuildEnv = {
            NEXT_PUBLIC_ENTE_ENDPOINT = "https://api.${mainDomain}";
            NEXT_PUBLIC_ENTE_ALBUMS_ENDPOINT = "https://albums.${mainDomain}";
            NEXT_TELEMETRY_DISABLED = "1";
          };
        };

      in
      {
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
          ${mainDomain} = {
            forceSSL = true;
            enableACME = true;
          };
          "api.${mainDomain}" = {
            forceSSL = true;
            enableACME = true;
          };
          "accounts.${mainDomain}" = {
            forceSSL = true;
            enableACME = true;
          };
          "cast.${mainDomain}" = {
            forceSSL = true;
            enableACME = true;
          };
          "albums.${mainDomain}" = {
            forceSSL = true;
            enableACME = true;

            locations."/" = {
              root = ente-web-albums;
              tryFiles = "$uri $uri.html /index.html";
              extraConfig = ''
                add_header Access-Control-Allow-Origin 'https://api.${mainDomain}';
              '';
            };
          };
        };

        ###################################################
        # SERVICES                                        #
        ###################################################
        services = {
          ente = {
            web = {
              enable = true;
              # package = pkgs.ente-web.overrideAttrs (
              #   _:
              #   let
              #     enteMainUrl = config.services.ente.web.domains.photos;
              #   in
              #   {
              #     postPatch = # Use our `wasm-pack` binary, rather than the Node version, which is
              #       # just a wrapper that tries to download the actual binary
              #       ''
              #         substituteInPlace \
              #           packages/wasm/package.json \
              #           --replace-fail "wasm-pack " ${lib.escapeShellArg "${pkgs.wasm-pack}/bin/wasm-pack "}
              #       ''
              #       # Replace hardcoded ente.io urls if desired
              #       + lib.optionalString (enteMainUrl != null) ''
              #         substituteInPlace \
              #           apps/accounts/src/pages/index.tsx \
              #           --replace-fail "https://web.ente.io" ${lib.escapeShellArg enteMainUrl}
              #       '';
              #   }
              # );
              domains = {
                photos = mainDomain;
                api = "api.${mainDomain}";
                albums = "albums.${mainDomain}";
                accounts = "accounts.${mainDomain}";
                cast = "cast.${mainDomain}";
              };
            };
            api = {
              enable = true;
              nginx.enable = true;
              enableLocalDB = true;
              domain = "api.${mainDomain}";
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
]
