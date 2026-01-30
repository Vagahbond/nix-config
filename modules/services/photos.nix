{
  targets = [
    "platypute"
  ];

  nixosConfiguration =
    {
      config,
      pkgs,
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
        "albums.pics.vagahbond.com" = {
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
              #              apps = {
              # public-albums = "albums.pics.vagahbond.com";
              # accounts = "accounts.pics.vagahbond.com";
              #             };
              s3 = {
                are_local_buckets = false;
                use_path_style_urls = false;
                b2-eu-cen = {
                  are_local_buckets = false;
                  use_path_style_urls = false;
                  key = "AKIAZI2LIHXHGU2IFURD";
                  # TODO: own secret
                  secret._secret = config.age.secrets.enteS3Secret.path;
                  # endpoint = "com.amazonaws.ap-southeast-2.s3";
                  region = "ap-southeast-2";
                  bucket = "vagahbond-nextcloud-s3";
                };
              };
              key = {
                encryption = "yvmG/RnzKrbCb9L3mgsmoxXr9H7i2Z4qlbT0mL3ln4w=";
                hash = "KXYiG07wC7GIgvCSdg+WmyWdXDAn6XKYJtp/wkEU7x573+byBRAYtpTP0wwvi8i/4l37uicX1dVTUzwH3sLZyw==";
              };
              # JWT secrets
              jwt = {
                secret = "i2DecQmfGreG6q1vBj5tCokhlN41gcfS2cjOs9Po-u8=";
              };
              internal = {
                admin = "1580559962386438";
                hardcoded-ott = {
                  emails = [
                    "vagahbond@pm.me,123456"
                    "victoria.graignic@proton.me,123456"
                  ];
                };
              };
            };
          };
        };
      };
    };
}
