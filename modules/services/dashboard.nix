{
  targets = [ "platypute" ];

  nixosConfiguration =
    { config, ... }:
    {
      environment.persistence.${config.persistence.storageLocation} = {
        directories = [
          "/var/lib/glance"
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
            server.port = 9981;
          };
        };
      };
    };
}
