[
  {
    targets = [ "nixosConfiguration" ];
    conf =
      {
        pkgs,
        config,
        ...
      }:
      let
        username = "j_sk8";

        upgradeScript = pkgs.writeScriptBin "upgrade" ''
          rm -r /tmp/tmpflake;
          git clone --depth 1 https://git.vagahbond.com/vagahbond/nix-config /tmp/tmpflake;

          nix flake update mkReset tournament --flake /tmp/tmpflake;

          nh os switch -R /tmp/tmpflake/.;

          rm -rf /tmp/tmpflake;
        '';

      in
      {

        users.users = {
          ${username} = {
            isNormalUser = true;

            extraGroups = [
              "wheel"
              username
            ];

            openssh.authorizedKeys.keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDr8QDLbHVJFcCYfbJW0sbACpX6RWrFig/nHfUbXNbx1 yoniserv"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILFusXTBhXLpViUVKjfHRJnjVb6WZFrxYq2/0Kh7MKwN pro@yoni-firroloni.com"
            ];
          };
        };

        services = {
          postgresql = {
            enable = true;
            initialScript = pkgs.writeText "j_sk8-grants.sql" ''
                            
              GRANT ALL PRIVILEGES ON DATABASE mk_reset TO ${username};
              GRANT ALL PRIVILEGES ON DATABASE tournament TO ${username};

              \c mk_reset
              GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO ${username};
              GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO ${username};
              GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO ${username};

              \c tournament
              GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO ${username};
              GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO ${username};
              GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO ${username};
            '';

            ensureUsers = [
              {
                name = username;
              }
            ];
          };
        };

        nix.settings.trusted-users = [ username ];

        environment.systemPackages = [ upgradeScript ];

        age.secrets = {
          j_sk8GitKey = {
            file = ../../secrets/github_access.age;
            owner = "root";
            mode = "0400";
          };
        };

        home-files.root = {
          ".ssh/config".text = ''
            Host github.com
              HostName github.com
              PreferredAuthentications publickey
              IdentityFile ${config.age.secrets.j_sk8GitKey.path}
          '';
          #          ".ssh/github_access.pub".text =
          #           "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBi/qH3wsZVyF61Wd1qgwvzx5VRl4uPYEWNxSCbYLC+n vagahbond@framework";

        };

        security.sudo = {
          enable = true;
          extraRules = [
            {
              # allow wheel group to run nixos-rebuild without password
              # this s a less vulnerable alternative to having wheelNeedsPassword = false
              users = [
                username
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
                  command = "/run/current-system/sw/bin/systemctl restart tournament-api.service";
                  options = [ "NOPASSWD" ];
                }
                {
                  command = "/run/current-system/sw/bin/migrate-tournament-db";
                  options = [ "NOPASSWD" ];
                }
                {
                  command = "/run/current-system/sw/bin/psql -d tournament";
                  options = [ "NOPASSWD" ];
                }
                {
                  command = "/run/current-system/sw/bin/psql -d mk_reset";
                  options = [ "NOPASSWD" ];
                }
              ];
            }
          ];
        };
      };
  }
]
