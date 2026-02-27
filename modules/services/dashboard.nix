{
  targets = [ "platypute" ];

  nixosConfiguration =
    { config, ... }:
    {
      environment.persistence.${config.persistence.storageLocation} = {
        directories = [
          "/var/lib/private/glance"
        ];
      };

      services = {
        nginx.virtualHosts."dash.vagahbond.com" = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString config.services.glance.settings.server.port}";
            proxyWebsockets = true; # needed if you need to use WebSocket
          };
        };

        glance = {
          enable = true;
          settings = {
            pages = [
              {
                name = "startpage";
                width = "slim";
                center-vertically = true;
                columns = [
                  {
                    size = "full";
                    widgets = [
                      {
                        type = "search";
                        autofocus = true;
                      }
                      {
                        type = "monitor";
                        cache = "1m";
                        title = "Services";
                        sites = [
                          {
                            title = "Nextcloud";
                            url = "https://nuage.vagahbond.com";
                            icon = "si:nextcloud";
                          }
                          {
                            title = "Pass";
                            url = "https://pass.vagahbond.com";
                            icon = "si:bitwarden";
                          }
                        ];
                      }
                    ];
                  }
                ];
              }
            ];
          };
          server.port = 9981;
        };
      };
    };
}
