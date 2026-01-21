{
  name = "air";
  platform = "aarch64-darwin";

  configuration =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [ git ];
    };
}
