{
  targets = [
    "platypute"
  ];

  nixosConfiguration =
    { config, ... }:
    {

      ###################################################
      # IMPERMANENCE                                    #
      ###################################################
      environment.persistence.${config.persistence.storageLocation} = {
        directories = [
          {
            directory = "/var/lib/actual";
            user = "actual";
            group = "actual";
            mode = "u=rwx,g=rx,o=";
          }
        ];
      };

      ###################################################
      # SERVICES                                        #
      ###################################################

      user.users.actual = {
        isSystemUser = true;
        group = "actual";
        home = config.services.actual.settings.datadir;
      };

      groups.actual = { };

      services.actual = {
        enable = true;
        group = "actual";
        user = "actual";

        settings = {
          port = 3054;
          datadir = "/var/lib/actual";
        };
      };

      ###################################################
      # SSL                                             #
      ###################################################
      services.nginx.virtualHosts."money.vagahbond.com" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://${config.services.actual.settings.hostname}:${toString config.services.actual.settings.port}";
          proxyWebsockets = true; # needed if you need to use WebSocket
        };
      };
    };
}
