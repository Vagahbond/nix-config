{
  targets = [
    "air"
    "platypute"
    "framework"
  ];

  sharedConfiguration = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      slumber
    ];
  };

  nixosConfiguration = {
    username,
    config,
    pkgs,
    ...
  }: let
    inherit (config.persistence) storageLocation;
  in {
    environment = {
      systemPackages = with pkgs; [
        wget
        curlWithGnuTls
        slumber
      ];

      persistence.${storageLocation} = {
        users.${username} = {
          directories = [
            ".config/slumber/"
            ".local/share/slumber/"
          ];
        };
      };
    };
  };
}
