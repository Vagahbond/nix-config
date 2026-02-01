{
  targets = [
    "platypute"
    "framework"
  ];

  nixosConfiguration = {
    pkgs,
    config,
    ...
  }: {
    # Works with wgnord and wg-quick
    # Remember to create /var/lib/wgnord/template.conf (nix module could do that for you but I need to work rn)
    # Remember to wg-quick down and up for it to work.

    environment = {
      systemPackages = with pkgs; [
        wgnord
        wireguard-tools
      ];

      persistence.${config.persistence.storageLocation} = {
        directories = [
          "/var/lib/wgnord"
          "/etc/wireguard/"
        ];
      };
    };
  };
}
