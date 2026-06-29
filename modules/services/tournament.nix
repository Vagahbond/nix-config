[
  {
    targets = [ "nixosConfiguration" ];
    conf =
      {
        config,
        inputs,
        pkgs,
        ...
      }:
      let
        serviceName = "tournament";
      in
      {
        imports = [
          inputs.tournament.nixosModules.default
        ];

        users.users.${serviceName} = {
          isSystemUser = true;
          group = serviceName;
          extraGroups = [ "j_sk8" ];
        };

        # REVERSE PROXY
        services.nginx.virtualHosts = {
          "tournament.mkreset.fr" = {
            forceSSL = true;
            enableACME = true;
            locations = {
              "/" = {
                root = "${inputs.tournament.packages.${pkgs.stdenv.hostPlatform.system}.frontend}";
                tryFiles = "$uri $uri/ /index.html";
              };

              "/api/" = {
                proxyPass = "http://localhost:${toString config.services.tournament.backend.port}";
                proxyWebsockets = true; # needed if you need to use WebSocket
              };

              "/uploads/" = {
                proxyPass = "http://localhost:${toString config.services.tournament.backend.port}";
                proxyWebsockets = true; # needed if you need to use WebSocket
              };

              "/socket.io/" = {
                proxyPass = "http://localhost:${toString config.services.tournament.backend.port}";
                proxyWebsockets = true; # needed if you need to use WebSocket
              };
            };
          };
        };

        # SECRETS
        age.secrets = {
          tournamentEnv = {
            file = ../../secrets/tournament_env.age;
            mode = "440";
            owner = serviceName;
            group = serviceName;
          };
        };

        # SERVICE
        services.tournament = {
          enable = true;

          user = serviceName;

          envFile = config.age.secrets.tournamentEnv.path;
          backend = {
            port = "8657";
          };
        };
      };
  }
]
