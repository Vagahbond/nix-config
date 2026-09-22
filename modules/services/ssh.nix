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

        # Podman (via netavark) manages its rules through native nftables.
        # fail2ban defaults to legacy iptables actions, and mixing iptables
        # (xtables-nft compat) calls with raw nftables tables made fail2ban
        # crash with a generic "OSError(61, 'No data available')" on start.
        # Forcing nftables here keeps both on the same backend.
        # If podman is removed later, this workaround can likely go too.
        networking.nftables.enable = true;

        services = {
          fail2ban = {
            enable = true;
            #   banaction = "nftables-multiport";
            #   banaction-allports = "nftables-allports";
          };
          openssh = {
            enable = true;
            settings = {
              PasswordAuthentication = false;
            };
          };
        };
      };
  }
]
