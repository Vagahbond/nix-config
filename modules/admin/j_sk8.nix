[
  {
    targets = [ "nixosConfiguration" ];
    conf =
      {
        inputs,
        pkgs,
        config,
        ...
      }:
      let
        username = "j_sk8";

        upgradeScript = pkgs.writeScriptBin "upgrade" ''
          rm -r /tmp/tmpflake;
          git clone --depth 1 https://github.com/vagahbond/nix-config /tmp/tmpflake;

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

        nix.settings.trusted-users = [ username ];

        environment.systemPackages = [ upgradeScript ];

        age.secrets = {
          j_sk8GitKey = {
            file = ../../secrets/github_access.age;
            owner = username;
            mode = "0400";
          };
          j_sk8SshConfig = {
            file = ../../secrets/ssh_config.age;
            owner = username;
            mode = "0400";
          };
        };

        home-files.${username} = {
          ".ssh/config".source = config.age.secrets.j_sk8SshConfig.path;
          ".ssh/github_access.pub".text =
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBi/qH3wsZVyF61Wd1qgwvzx5VRl4uPYEWNxSCbYLC+n vagahbond@framework";
          ".ssh/github_access".source = config.age.secrets.j_sk8GitKey.path;

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
              ];
            }
          ];
        };
      };
  }
]
