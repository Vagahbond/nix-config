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
        harlequin # comes with Postgres adapter inbuilt?
      ];
    };

  nixosConfiguration =
    {
      config,
      username,
      ...
    }:
    {
      #   environment.persistence.${config.persistence.storageLocation} = {
      #     users.${username} = {
      #       directories = [
      #         ".config/Harlequin"
      #       ];
      #     };
      #   };
    };
}
