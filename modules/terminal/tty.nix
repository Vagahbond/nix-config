[
  {
    targets = [
      "nixosConfiguration"
    ];
    conf =
      {
        pkgs,
        ...
      }:
      {
        console = {
          font = "${pkgs.nerd-fonts.bigblue-terminal}/share/fonts/truetype/NerdFonts/BigBlueTerm/BigBlueTermPlusNerdFontMono-Regular.ttf";
          colors = [
            "191724"
            "1f1d2e"
            "26233a"
            "6e6a86"
            "908caa"
            "e0def4"
            "e0def4"
            "524f67"
            "eb6f92"
            "f6c177"
            "ebbcba"
            "31748f"
            "9ccfd8"
            "c4a7e7"
            "f6c177"
            "524f67"
          ];
        };

      };
  }
]
