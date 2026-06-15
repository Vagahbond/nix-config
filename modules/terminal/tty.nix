[
  {
    targets = [
      "nixosConfiguration"
    ];
    conf =
      {
        config,
        pkgs,
        ...
      }:
      {
        fonts.packages = [
          pkgs.nerd-fonts.departure-mono
          pkgs.nerd-fonts.mononoki
        ];
        console = {
          font = "Departure Mono Nerd Font Mono";
          colors = [

            "191724"
            "eb6f92"
            "31748f"
            "f6c177"
            "9ccfd8"
            "ebbcba"
            "c4a7e7"
            "e0def4"
            "191724"
            "eb6f92"
            "1f1d2e"
            "26233a"
            "6e6a86"
            "c4a7e7"
            "6e6a86"
            "e0def4"
          ];
        };

      };
  }
]
