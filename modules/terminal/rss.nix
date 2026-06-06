[

  {
    targets = [ "androidConfiguration" ];
    conf =
      { pkgs, ... }:
      {
        environment.packages = with pkgs; [
          bulletty
        ];
      };
  }
  {
    targets = [
      "nixosConfiguration"
      "darwinConfiguration"
    ];
    conf =
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
]
