{
  targets = [
    "framework"
  ];

  sharedConfiguration =
    { pkgs, ... }:
    {
      environment = {
        systemPackages = with pkgs; [
          libreoffice
        ];
      };
    };

  nixosConfiguration =
    {
      config,
      username,
      ...
    }:
    {
      environment.persistence.${config.impermanence.storageLocation} = {
        users.users.${username} = {
          directories = [
            ".config/libreoffice"
          ];
          files = [
          ];
        };
      };
    };
}
