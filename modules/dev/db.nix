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
        harlequin
        python313Packages.harlequin-postgres
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
