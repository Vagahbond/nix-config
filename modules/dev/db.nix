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
        lazysql
      ];
    };
}
