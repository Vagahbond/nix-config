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
      enviornment.systemPackages = with pkgs; [
        bulletty
      ];
    };
}
