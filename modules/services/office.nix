{
  targets = [
    "platypute"
  ];

  nixosConfiguration =
    {
      pkgs,
      config,
      ...
    }:
    {
      environment.persistence.${config.persistence.storageLocation} = {
        directories = [
          "/var/lib/cool"
        ];
      };

      fonts.packages = with pkgs; [
        nerd-fonts.departure-mono
        corefonts
      ];

      services.nginx.virtualHosts."office.vagahbond.com" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://[::1]:${toString config.services.collabora-online.port}";
          proxyWebsockets = true; # needed if you need to use WebSocket
        };
      };

      services.collabora-online = {
        enable = true;
        port = 9980;
        settings = {
          # Rely on reverse proxy for SSL
          ssl = {
            enable = false;
            termination = true;
          };

          # Listen on loopback interface only, and accept requests from ::1
          net = {
            content_security_policy = "frame-ancestors https://files.vagahbond.com;";
            listen = "loopback";
            post_allow.host = [
              "::1"
            ];
          };

          storage.wopi = {
            "@allow" = true;
            alias_groups = {
              "@mode" = "groups";
              group = [
                {
                  host = "files.vagahbond.com";
                }
              ];
            };
            # "@allow" = true;
            # # TODO: use a variable for the FQDN
            # host = [
            #   "files.vagahbond.com"
            # ];
          };

          # Set FQDN of server
          server_name = "office.vagahbond.com";
        };
      };

      ###################################################################
      # COLLABORA                                                    #
      ###################################################################

      networking.hosts = {
        "127.0.0.1" = [
          "office.vagahbond.com"
          "files.vagahbond.com"
        ];
        "::1" = [
          "office.vagahbond.com"
          "files.vagahbond.com"
        ];
      };

    };
}
