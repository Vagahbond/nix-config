{
  targets = [
    "platypute"
  ];

  nixosConfiguration =
    {
      config,
      inputs,
      username,
      pkgs,
      ...
    }:
    let
      # MAINTENANCE

      keys = import ../../secrets/sshKeys.nix {
        inherit username config pkgs;
      };

      serviceUser = "mk_reset";

      upgradeScript = pkgs.writeScriptBin "upgrade" ''
        rm -r /tmp/tmpflake;
        git clone https://github.com/vagahbond/nix-config /tmp/tmpflake;

        nix flake update mkReset --flake /tmp/tmpflake;

        nh os switch -R /tmp/tmpflake/.;
      '';

    in
    {
      imports = [
        inputs.mkReset.nixosModules.default
      ];

      users.users = {
        ${serviceUser} = {
          isSystemUser = pkgs.lib.mkForce false;
          isNormalUser = true;

          extraGroups = [
            "wheel"
          ];

          openssh.authorizedKeys.keys = with keys; [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDr8QDLbHVJFcCYfbJW0sbACpX6RWrFig/nHfUbXNbx1 yoniserv"
            platypute_access.pub
          ];
        };
      };

      nix.settings.trusted-users = [ serviceUser ];

      security.sudo = {
        enable = true;
        extraRules = [
          {
            # allow wheel group to run nixos-rebuild without password
            # this s a less vulnerable alternative to having wheelNeedsPassword = false
            users = [
              serviceUser
            ];

            commands = [
              {
                command = "/run/current-system/sw/bin/upgrade";
                options = [ "NOPASSWD" ];
              }
              {
                command = "/run/current-system/sw/bin/systemctl restart mario-crade-backend.service";
                options = [ "NOPASSWD" ];
              }
              {
                command = "/run/current-system/sw/bin/systemctl restart mario-crade-frontend.service";
                options = [ "NOPASSWD" ];
              }
              {

                command = "/run/current-system/sw/bin/systemctl status mario-crade-backend.service";
                options = [ "NOPASSWD" ];
              }
              {
                command = "/run/current-system/sw/bin/systemctl status mario-crade-frontend.service";
                options = [ "NOPASSWD" ];
              }

            ];
          }
        ];
      };

      environment.systemPackages = [ upgradeScript ];

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
        /*
          "api.mkreset.fr" = {
            forceSSL = true;
            enableACME = true;

            locations."/" = {
              proxyPass = "http://localhost:${toString config.services.mkReset.frontend.port}";
              proxyWebsockets = true; # needed if you need to use WebSocket
            };
          };
        */
        "mario-crade.touches-grasses.fr" = {
          forceSSL = true;
          enableACME = true;
          basicAuthFile = config.age.secrets.mkResetPassword.path;
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
          owner = serviceUser;
          group = serviceUser;
        };

        mkResetPassword = {
          file = ../../secrets/mk_reset_pwd.age;
          mode = "440";
          owner = "nginx";
          group = "nginx";
        };
      };

      # SERVICE
      services.mkReset = {
        enable = true;

        user = serviceUser;

        envFile = config.age.secrets.mkResetEnv.path;
      };

    };
}
