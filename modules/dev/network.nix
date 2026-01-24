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
        slumber
      ];
    };

  nixosConfiguration =
    {
      username,
      config,
      pkgs,
      ...
    }:
    {

      environment.systemPackages = with pkgs; [
        wget
        curlWithGnuTls
        slumber
      ];

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
