{
  pkgs,
  storageLocation,
  config,
  ...
}: {
  /*
    environment.persistence.${storageLocation} = {
    directories = [
    ];
  };
  */

  services.nginx.virtualHosts."office.vagahbond.com" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://localhost:${toString config.services.collabora-online.port}";
      proxyWebsockets = true; # needed if you need to use WebSocket
    };
  };

  services.collabora-online = {
    enable = true;
    port = 9980;
  };
}
