{
  storageLocation,
  ...
}: {
  environment.persistence.${storageLocation} = {
    # TODO: independent redis and rabbitmq with special volume
    directories = [
      {
        directory = "/var/lib/silverbullet";
        user = "silverbullet";
        group = "silverbullet";
        mode = "u=rwx,g=rx,o=";
      }
    ];
  };

  services.silverbullet = {
    enable = true;
    listenPort = 3888;
  };

    services.nginx.virtualHosts."notes.vagahbond.com" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8080";
      proxyWebsockets = true; # needed if you need to use WebSocket
    };
  };

}
