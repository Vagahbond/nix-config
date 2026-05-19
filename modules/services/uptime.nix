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

      # age.secrets = {
      #   opencloudEnv = {
      #     file = ../../secrets/opencloud_env.age;
      #     mode = "440";
      #     owner = config.services.opencloud.user;
      #     group = config.services.opencloud.group;
      #
      #   };
      #
      # };

      # environment.persistence.${config.persistence.storageLocation} = {
      #   directories = [
      #     {
      #       directory = config.services.opencloud.stateDir;
      #       inherit (config.services.opencloud) user group;
      #       mode = "u=rwx,g=rx,o=";
      #     }
      #     {
      #       directory = "/etc/opencloud";
      #       inherit (config.services.opencloud) user group;
      #       mode = "u=rwx,g=rx,o=";
      #     }
      #     # {
      #     #   directory = "/var/lib/radicale";
      #     #   user = "radicale";
      #     #   group = "radicale";
      #     #   mode = "u=rwx,g=rx,o=";
      #     # }
      #   ];
      # };

      services = {
        nginx.virtualHosts = {
          "uptime.vagahbond.com" = {
            forceSSL = true;
            enableACME = true;
            locations."/" = {
              proxyPass = "http://127.0.0.1:${toString config.services.uptime-kuma.settings.PORT}";
              proxyWebsockets = true; # needed if you need to use WebSocket
            };
          };

        };

        uptime-kuma = {
          enable = true;

          settings = {

            # NODE_EXTRA_CA_CERTS = {
            #   _type = "literalExpression";
            #   text = "config.security.pki.caBundle";
            # };
            PORT = "4492";
            UPTIME_KUMA_DB_TYPE = "sqlite";
            # DATA_DIR = "/var/lib/uptime-kuma";
          };

        };
      };
      users.users.uptime-kuma = {
        isSystemUser = true;
        group = "uptime-kuma";
        home = "/var/lib/uptime-kuma";
      };
      users.groups.uptime-kuma = { };
    };
}
