{
  colors,
  font,
  mkRGB,
  mkRGBA,
  mkHex,
  mkFontName,
  ...
}: ''
  Hello this is a test

  to make a template

  and use colors as arg : ${mkRGB colors.base00}
  and use colors as arg : ${mkRGBA colors.base00}
  and use colors as arg : ${mkHex colors.base00 {
    alpha = true;
    hashtag = true;
  }}
  and use colors as arg : ${mkHex colors.base00 {
    alpha = false;
    hashtag = false;
  }}
  and use colors as arg : ${mkHex colors.base00 {
    alpha = true;
    hashtag = false;
  }}
  and use colors as arg : ${mkHex colors.base00 {
    alpha = false;
    hashtag = true;
  }}

  and this color symbolizes the good : ${mkHex colors.good {}}

  and also this font ${builtins.toJSON font.name}

  but it can also be ${builtins.toJSON (mkFontName {
    propo = true;
    bold = true;
    italic = true;
  })}


''
