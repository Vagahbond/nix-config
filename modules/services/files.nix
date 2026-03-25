{
  targets = [
    "platypute"
  ];

  nixosConfiguration =
    {
      config,
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
          {
            directory = "/etc/opencloud";
            inherit (config.services.opencloud) user group;
            mode = "u=rwx,g=rx,o=";
          }
          {
            directory = "/var/lib/radicale";
            user = "radicale";
            group = "radicale";
            mode = "u=rwx,g=rx,o=";
          }
        ];
      };

      services = {
        nginx.virtualHosts = {
          "files.vagahbond.com" = {
            forceSSL = true;
            enableACME = true;

            locations = {
              "/" = {
                extraConfig = ''
                  client_max_body_size 1G;
                '';
                proxyPass = "http://127.0.0.1:${toString config.services.opencloud.port}";
                proxyWebsockets = true; # needed if you need to use WebSocket
              };
              # Radicale endpoints for CalDAV and CardDAV
              #     "/caldav/" = {
              #       proxyPass = "http://127.0.0.1:5232";
              #       extraConfig = "
              #   proxy_set_header X-Remote-User $remote_user; # provide username to CalDAV
              #   proxy_set_header X-Script-Name /caldav;
              # ";
              #     };
              #     "/.well-known/caldav" = {
              #       proxyPass = "http://127.0.0.1:5232";
              #       extraConfig = "
              #   proxy_set_header X-Remote-User $remote_user; # provide username to CalDAV
              #   proxy_set_header X-Script-Name /caldav;
              # ";
              #     };
              #     "/carddav/" = {
              #       proxyPass = "http://127.0.0.1:5232";
              #       extraConfig = "
              #   proxy_set_header X-Remote-User $remote_user; # provide username to CardDAV
              #   proxy_set_header X-Script-Name /carddav;
              # ";
              #     };
              #     "/.well-known/carddav/" = {
              #       proxyPass = "http://127.0.0.1:5232";
              #       extraConfig = "
              #   proxy_set_header X-Remote-User $remote_user; # provide username to CardDAV
              #   proxy_set_header X-Script-Name /carddav;
              # ";
              #     };
            };

          };
        };

        opencloud = {
          enable = true;
          url = "https://files.vagahbond.com";
          environmentFile = config.age.secrets.opencloudEnv.path;
          port = 9208;
          settings = {
            # collaboration = {
            #   app = {
            #     name = "Collabora";
            #     addr = "https://office.vagahbond.com";
            #   };
            # };
            csp = {
              directives = {
                child-src = [
                  "'self'"
                ];

                connect-src = [
                  "'self'"
                  "blob:"
                  "https://\${COMPANION_DOMAIN|companion.opencloud.test}\${TRAEFIK_PORT_HTTPS}/"
                  "wss://\${COMPANION_DOMAIN|companion.opencloud.test}\${TRAEFIK_PORT_HTTPS}/"
                  "https://raw.githubusercontent.com/opencloud-eu/awesome-apps/"
                  "https://\${IDP_DOMAIN|keycloak.opencloud.test}\${TRAEFIK_PORT_HTTPS}/"
                  "https://update.opencloud.eu/"
                ];

                default-src = [
                  "'none'"
                ];

                font-src = [
                  "'self'"
                ];

                frame-ancestors = [
                  "'self'"
                ];

                frame-src = [
                  "'self'"
                  "blob:"
                  "https://embed.diagrams.net"
                  # In contrary to bash and docker the default is given after the | character
                  "https://office.vagahbond.com"
                  # This is needed for the external-sites web extension when embedding sites
                  "https://docs.opencloud.eu"
                ];

                img-src = [
                  "'self'"
                  "data:"
                  "blob:"
                  "https://raw.githubusercontent.com/opencloud-eu/awesome-apps/"
                  "https://tile.openstreetmap.org/"
                  # In contrary to bash and docker the default is given after the | character
                  "https://office.vagahbond.com/"
                ];

                manifest-src = [
                  "'self'"
                ];

                media-src = [
                  "'self'"
                ];

                object-src = [
                  "'self'"
                  "blob:"
                ];

                script-src = [
                  "'self'"
                  "'unsafe-inline'"
                  "https://\${IDP_DOMAIN|keycloak.opencloud.test}\${TRAEFIK_PORT_HTTPS}/"
                ];

                style-src = [
                  "'self'"
                  "'unsafe-inline'"
                ];
              };
            };
            proxy = {
              csp_config_file_location = "/etc/opencloud/csp.yaml";
              additional_policies = [
                {
                  name = "default";
                  routes = [
                    {
                      endpoint = "/caldav/";
                      backend = "http://127.0.0.1:5232";
                      remote_user_header = "X-Remote-User";
                      skip_x_access_token = true;
                      additional_headers = [ { "X-Script-Name" = "/caldav"; } ];
                    }
                    {
                      endpoint = "/.well-known/caldav";
                      backend = "http://127.0.0.1:5232";
                      remote_user_header = "X-Remote-User";
                      skip_x_access_token = true;
                      additional_headers = [ { "X-Script-Name" = "/caldav"; } ];
                    }
                    {
                      endpoint = "/carddav/";
                      backend = "http://127.0.0.1:5232";
                      remote_user_header = "X-Remote-User";
                      skip_x_access_token = true;
                      additional_headers = [ { "X-Script-Name" = "/carddav"; } ];
                    }
                    {
                      endpoint = "/.well-known/carddav";
                      backend = "http://127.0.0.1:5232";
                      remote_user_header = "X-Remote-User";
                      skip_x_access_token = true;
                      additional_headers = [ { "X-Script-Name" = "/carddav"; } ];
                    }
                  ];
                }
              ];
            };
          };
        };

        radicale = {
          enable = true;
          settings = {
            server = {
              hosts = [ "127.0.0.1:5232" ];
              ssl = false; # disable SSL, only use when behind reverse proxy
            };
            auth = {
              type = "http_x_remote_user"; # disable authentication, and use the username that OpenCloud provides is
              strip_domain = false;
            };
            web = {
              type = "none";
            };
            storage = {
              filesystem_folder = "/var/lib/radicale/collections";
            };
            # logging = {
            #   level = "debug"; # optional, enable debug logging
            #   bad_put_request_content = true; # only if level=debug
            #   request_header_on_debug = true; # only if level=debug
            #   request_content_on_debug = true; # only if level=debug
            #   response_content_on_debug = true; # only if level=debug
            # };
          };
        };
      };

    };
}
