[
  {
    targets = [
      "nixosConfiguration"
      "darwinConfiguration"
      "androidConfiguration"
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
