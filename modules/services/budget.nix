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

      # systemd.tmpfiles.rules = [
      #   "d ${config.services.actual.settings.userFiles} 0755 ${config.services.actual.user} ${config.services.actual.group} -"
      #   "d ${config.services.actual.settings.serverFiles} 0755 ${config.services.actual.user} ${config.services.actual.group} -"
      # ];

      ###################################################
      # SERVICES                                        #
      ###################################################

      users.users.actual = {
        isSystemUser = true;
        group = "actual";
        #  home = config.services.actual.settings.datadir;
      };

      users.groups.actual = { };

      services.actual = {
        enable = true;
        group = "actual";
        user = "actual";

        settings = {
          port = 3054;
          hostname = "localhost";
          dataDir = "/var/lib/actual";
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
