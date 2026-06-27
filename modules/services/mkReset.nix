[
  {
    targets = [ "nixosConfiguration" ];
    conf =
      {
        config,
        inputs,
        ...
      }:
      let
        serviceName = "mk_reset";
      in
      {
        imports = [
          inputs.mkReset.nixosModules.default
        ];

        users.users.${serviceName} = {
          isSystemUser = true;
          group = serviceName;
          extraGroups = [ "j_sk8" ];
        };

        # REVERSE PROXY
        services.nginx.virtualHosts = {
          "mkreset.fr" = {
            forceSSL = true;
            enableACME = true;

            locations."/" = {
              proxyPass = "http://localhost:${toString config.services.mkReset.frontend.port}";
              proxyWebsockets = true; # needed if you need to use WebSocket
            };
          };
        };

        # SECRETS
        age.secrets = {
          mkResetEnv = {
            file = ../../secrets/mk_reset_env.age;
            mode = "440";
            owner = serviceName;
            group = serviceName;
          };
        };

        # SERVICE
        services.mkReset = {
          enable = true;

          user = serviceName;

          envFile = config.age.secrets.mkResetEnv.path;
        };
      };
  }
]
