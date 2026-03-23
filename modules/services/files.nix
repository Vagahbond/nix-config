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

      age.secrets = {
        opencloudEnv = {
          file = ../../secrets/opencloud_env.age;
          mode = "440";
          owner = config.services.opencloud.user;
          group = config.services.opencloud.group;

        };

      };

      environment.persistence.${config.persistence.storageLocation} = {
        # TODO = independent redis and rabbitmq with special volume
        directories = [
          {
            directory = config.services.opencloud.stateDir;
            inherit (config.services.opencloud) user group;
            mode = "u=rwx,g=rx,o=";
          }
        ];
      };

      services = {
        nginx.virtualHosts = {
          ${config.services.opencloud.url} = {
            forceSSL = true;
            enableACME = true;

            locations."/" = {
              extraConfig = ''
                client_max_body_size 100M;
              '';
              proxyPass = "http://127.0.0.1:${toString config.services.opencloud.port}";
              proxyWebsockets = true; # needed if you need to use WebSocket
            };

          };
        };

        opencloud = {
          enable = true;
          url = "https://files.vagahbond.com";
          environmentFile = config.age.secrets.opencloudEnv.path;
        };
      };

      imports = [ inputs.filestash.nixosModules.default ];

      ###################################################################
      # IMPERMANENCE                                                    #
      ###################################################################
      environment.persistence.${config.persistence.storageLocation} = {
        # TODO = independent redis and rabbitmq with special volume
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
        # filestashApiKey = {
        #   file = ../../secrets/filestash_api_key.age;
        #   mode = "440";
        #   owner = config.services.filestash.user;
        #   group = config.services.filestash.group;
        # };

      };

      ###################################################
      # SSL                                             #
      ###################################################

      # services.nginx.virtualHosts = {
      #   "files.vagahbond.com" = {
      #     forceSSL = true;
      #     enableACME = true;
      #
      #     locations."/" = {
      #       extraConfig = ''
      #         client_max_body_size 100M;
      #       '';
      #       proxyPass = "http://127.0.0.1:8334";
      #       proxyWebsockets = true; # needed if you need to use WebSocket
      #     };
      #
      #   };
      # };

      ###################################################
      # SERVICES                                        #
      ###################################################
      services.filestash = {
        enable = true;

        paths = {
          config = "/var/lib/filestash/config.json";
        };

        # Cannot really make reproducible without heavily improving the nixos module

        #   settings = {
        #     general = {
        #       secret_key_file = config.age.secrets.filestashSecretKey.path;
        #       name = "La boite à fichiers";
        #       port = 8334;
        #       host = "files.vagahbond.com";
        #       force_ssl = true;
        #       editor = "base";
        #       fork_button = null;
        #       logout = "https://rickastley.co.uk/";
        #       display_hidden = true;
        #       refresh_after_upload = true;
        #       upload_button = true;
        #       upload_pool_size = null;
        #       upload_chunk_size = null;
        #       filepage_default_view = null;
        #       filepage_default_sort = null;
        #       cookie_timeout = null;
        #       custom_css = null;
        #     };
        #     features = {
        #       api = {
        #         enable = null;
        #         api_key_file = config.age.secrets.filestashApiKey.path;
        #       };
        #       share = {
        #         enable = null;
        #         default_access = null;
        #         redirect = null;
        #       };
        #       protection = {
        #         iframe = null;
        #         enable_chromecast = false;
        #         signature = null;
        #         disable_svg = null;
        #         zip_timeout = null;
        #         disable_csp = null;
        #       };
        #       mcp = {
        #         enable = null;
        #         can_edit = null;
        #       };
        #       server = {
        #         console_enable = false;
        #       };
        #       search = {
        #         explore_timeout = null;
        #       };
        #       office = {
        #         office_server = "http://[::1]:9980";
        #         filestash_server = "https://files.vagahbond.com";
        #         rewrite_discovery_url = null;
        #         enable = true;
        #       };
        #       video = {
        #         blacklist_format = null;
        #         enable_transcoder = true;
        #       };
        #     };
        #     log = {
        #       enable = null;
        #       level = null;
        #       telemetry = true;
        #     };
        #     email = {
        #       server = null;
        #       port = null;
        #       username = null;
        #       password = null;
        #       from = null;
        #     };
        #     auth = {
        #       admin = "$2a$10$8Y0hz7hUrBpIqVO6XazpBup7g4y9yRk6KfV75kqrLhPyqISAOjKse";
        #     };
        #     middleware = {
        #       identity_provider = {
        #         type = "local";
        #         params = "DlwdmFvZHBh8hDgFI53TjjqYZSgjUawhX-v3voJtojeueSt2PJSZCHRw-DZTJ3EENY0nh-rM3k-Gbr20JiMzCfjTTfXrJr4AhxQxIVqAY1AJG_U28sr5zEP0JYZEps8lmk83T9AorPOCWHJo5j2LN0vaJkHZEx0Lt8yArPN9AKti4-TZwpM_hxjMvsuU8GNAUEA2dhW19XLCt3-uXYCYbPLh2Zp4zLcu8kPjmPP-XLzX4azylbGFVTWD1-r4IHnGtf9L-Ejw0sOrKeOKIdfxV1h6tjlzBbzvjycAvP7op55jT39eX40R9yNpyWWtiG8177uLrNDrdSkLq6WqkY0PffxEpy6hzn2syRWZA0LaFX9jXDRSxOEn82_1YDdLrqTK4XQiMgw=";
        #       };
        #       attribute_mapping = {
        #         related_backend = "AWS";
        #         params = "DlwdmFvZHBh8hDgGjEaYoEKuJFQfI1OGzjBDmTXKuYOoTJrVP6FBOsXnS9DB2963AuAp3xIRLnOnN9LWP9VAyiWWYhIDV3DaQHCXakmAACZKL66R6YlQ6okodDXDPY1gLDajJrkYSpXtGpEOpWB4S8Mjv8SxxOalEycUTdEOp0pSBboGAXaf9dk-4-vnFDHzFR8RTNUjO7355-D9IymSrmOIsHXSiC8hgBwNCmsS2bA2vtwy0EvydTW9OB_YiK-KVXgpXwIaAbCOL3aAwiuw2kcLtE5T0MOqx9k2BSEQ9uOEeBUvEZyw3A0pVHuSHmTW5zc8";
        #       };
        #     };
        #     constant = {
        #       user = "filestash";
        #       license = "agpl";
        #     };
        #     # To edit, copy config file to /var/lib/filestash/config.json and edit from admin panel
        #     connections = [
        #       {
        #         type = "s3";
        #         label = "AWS";
        #       }
        #     ];
        #
        #   };
      };
    };
}
