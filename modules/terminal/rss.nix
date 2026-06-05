{
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
