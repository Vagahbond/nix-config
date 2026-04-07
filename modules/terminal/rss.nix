{
  targets = [
    "air"
  ];

  sharedConfiguration =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        bulletty
      ];
    };
}
