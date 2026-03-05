{
  targets = [
    "platypute"
  ];

  nixosConfiguration =
    {
      config,
      pkgs,
      inputs,
      self,
      ...
    }:
    {
      imports = [ inputs.filestash.nixosModules.default ];

      ###################################################################
      # IMPERMANENCE                                                    #
      ###################################################################
      environment.persistence.${config.persistence.storageLocation} = {
        # TODO: independent redis and rabbitmq with special volume
        directories = [
          {
            directory = "/var/lib/filestash";
            user = config.services.filestash.user;
            group = config.services.filestash.group;
            mode = "u=rwx,g=rx,o=";
          }

          {
            directory = "/var/cache/filestash";
            user = config.services.filestash.user;
            group = config.services.filestash.group;
            mode = "u=rwx,g=rx,o=";
          }
        ];
      };

      ###################################################
      # SECRETS                                         #
      ###################################################
      age.secrets = {
        filestashSecretKey = {
          file = ../../secrets/filestash_secret_key.age;
          mode = "440";
          owner = config.services.filestash.user;
          group = config.services.filestash.group;
        };

      };

      ###################################################
      # SSL                                             #
      ###################################################

      services.nginx.virtualHosts = {
        "cloud.vagahbond.com" = {
          forceSSL = true;
          enableACME = true;
        };
      };

      ###################################################
      # SERVICES                                        #
      ###################################################
      services.filestash = {
        enable = true;
        settings = {
          general = {
            host = "cloud.vagahbond.com";
            port = 8334;
            secret_key_file = config.age.secrets.filestashSecretKey.path;
            editor = "base";
            fork_button = false;
            upload_button = true;
            filepage_default_view = "list";
            filepage_default_sort = "type";
          };
          share.default_access = "viewer";
          features.api.enable = false;
          auth = {
            admin = "$2a$12$6IeDB6RsGpntHVYqcADhteEwA7z/1AbUG1oj16Pkq9ibMSZP7tr06";
          };
          # connections = [ ];
        };
      };
    };
}
