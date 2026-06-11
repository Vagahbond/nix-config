[
  {
    targets = [ "nixosConfiguration" ];
    conf =
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
]
