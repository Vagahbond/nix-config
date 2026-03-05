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
        nextcloudAdminPass = {
          file = ../../secrets/nextcloud_admin_pass.age;
          mode = "440";
          owner = "filestash";
          group = "filestash";
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
      services.livestash = {
        enable = true;
        settings = {
          general = {
            host = "cloud.vagahbond.com";
            port = 8334;
            secret_key_file = config.age.secrets.filestash.path;
            editor = "base";
            fork_button = false;
            upload_button = true;
            filepage_default_view = "list";
            filepage_default_sort = "type";
          };
          share.default_access = "viewer";
          features.api.enable = false;
          auth.admin = "$2a$05$gIqN0/EbKTkj5iyZHjOgwOD6/ppQkKPzszkYGXSLvCuYapHWiACHC";
          connections = [ ];
        };
      };
    };
}
