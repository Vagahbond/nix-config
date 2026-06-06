[

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
