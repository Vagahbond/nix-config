# TODO: Host Affine without container layer
[
  {
    targets = [ "nixosConfiguration" ];
    conf =
      {
        config,
        inputs,
        pkgs,
        ...
      }:
      {

        imports = [
          inputs.affine-server.nixosModules.default
        ];

        ###################################################################
        # SECRETS                                                         #
        ###################################################################

        age.secrets.affineKey = {
          file = ../../secrets/affine_key.age;
          mode = "400";
          owner = config.services.affine-server.user;
          group = config.services.affine-server.group;
        };

        age.secrets.affineS3Secret = {
          file = ../../secrets/affine_s3_secret.age;
          mode = "400";
          owner = config.services.affine-server.user;
          group = config.services.affine-server.group;
        };

        ###################################################################
        # SERVICE                                                         #
        ###################################################################
        services.affine-server = {
          enable = true;

          package = inputs.affine-server.packages.${pkgs.system}.default;

          nginx = {
            enable = true;
            enableACME = true;
          };

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
              host = "notes.vagahbond.com";

            };

            storages = {
              blob.storage = {
                provider = "aws-s3";
                bucket = "vagahbond-affine-blobs";
                config = {
                  region = "ap-southeast-2";
                  credentials = {
                    secretAccessKey._secret = config.age.secrets.affineS3Secret.path;
                    accessKeyId = "AKIAZI2LIHXHDIZGJ3P5";
                  };
                };
              };
            };
          };
        };
      };
  }
]
