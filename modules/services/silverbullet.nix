{
  storageLocation,
  config,
  ...
}: {
  ###################################################################
  # PERSISTENCE                                                     #
  ###################################################################
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

  ###################################################################
  # SECRETS                                                         #
  ###################################################################
  age.secrets.silverbulletEnv = {
    file = ../../secrets/silverbullet_env.age;
    mode = "440";
    owner = "silverbullet";
    group = "silverbullet";
  };

  ###################################################################
  # SERVICE                                                         #
  ###################################################################
  services.silverbullet = {
    enable = true;
    listenPort = 3888;
    envFile = config.age.secrets.silverbulletEnv.path;
  };

  ###################################################################
  # PROXY                                                           #
  ###################################################################
  services.nginx.virtualHosts."notes.vagahbond.com" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:3888";
      proxyWebsockets = true; # needed if you need to use WebSocket
    };
  };
}
