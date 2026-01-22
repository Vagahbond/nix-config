{
  targets = [
    "air"
    "platypute"
    "framework"
  ];

  sharedConfiguration =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        wget
        curlWithGnuTls
        slumber
      ];
    };
  nixosConfiguration =
    { username, config, ... }:
    {

      persistence.${config.impermanence.storageLocation} = {
        users.${username} = {
          directories = [
            ".config/slumber/"
            ".local/share/slumber/"
          ];
        };
      };

    };
}
