[
  {
    targets = [ "nixosConfiguration" ];
    conf =
      {
        username,
        config,
        pkgs,
        ...
      }:
      let
        keys = import ../../secrets/sshKeys.nix { inherit username config pkgs; };
      in
      {
        users.users.${username}.openssh.authorizedKeys.keys = [
          keys."${config.networking.hostName}_access".pub
        ];

        services = {
          fail2ban.enable = true;
          openssh = {
            enable = true;
            settings = {
              PasswordAuthentication = false;
              Banner = toString (
                pkgs.writeText "banner.txt" ''
                  You just logged into ${config.networking.hostName}.
                  For inquiries, please contact vagahbond@pm.me.

                ''
              );
            };
          };
        };
      };
  }
]
