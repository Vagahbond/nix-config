{
  colors,
  font,
  mkRGB,
  mkRGBA,
  mkHex,
  mkHHex,
  mkHexA,
  mkHHexA,
  mkFontName,
  ...
}: ''
  Hello this is a test

  to make a template

  and use colors as arg : ${mkRGB colors.base00}
  and use colors as arg : ${mkRGBA colors.base00 0.5}
  and use colors as arg : ${
    mkHHex colors.base00
  }
  and use colors as arg : ${
    mkHex colors.base00
  }
  and use colors as arg : ${
    mkHexA colors.base00 "AA"
  }
  and use colors as arg : ${
    mkHHexA colors.base00 "AA"
  }

  and this color symbolizes the good : ${mkHex colors.good}

  and also this font ${builtins.toJSON font.name}

  but it can also be ${builtins.toJSON (mkFontName {
    propo = true;
    bold = true;
    italic = true;
  })}


''
