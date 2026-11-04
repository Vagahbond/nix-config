[
  {
    targets = [ "nixosConfiguration" ];
    conf = { config }: {
      services = {
        jellyfin = {
          enable = true;
          dataDir = "/var/lib/jellyfin";

        };
        nginx.virtualHosts."music.vagahbond.com" = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:8096";
            proxyWebsockets = true; # needed if you need to use WebSocket
          };
        };
      };
    };
  }
]
