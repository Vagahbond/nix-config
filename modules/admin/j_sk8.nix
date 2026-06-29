[
  {
    targets = [ "nixosConfiguration" ];
    conf =
      {
        inputs,
        pkgs,
        ...
      }:
      let
        username = "j_sk8";

        upgradeScript = pkgs.writeScriptBin "upgrade" ''
          rm -r /tmp/tmpflake;
          git clone https://github.com/vagahbond/nix-config /tmp/tmpflake;

          nix flake update mkReset tournament --flake /tmp/tmpflake;

          nh os switch -R /tmp/tmpflake/.;
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
