{
  targets = [
    "air"
    "platypute"
    "framework"
  ];

  sharedConfiguration = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      lazysql
    ];
  };

  nixosConfiguration = {
    config,
    username,
    ...
  }: {
    environment.persistence.${config.persistence.storageLocation} = {
      users.${username} = {
        directories = [
          ".config/lazysql"
        ];
      };
    };
  };
}
