{
  colors,
  font,
  mkRGB,
  mkRGBA,
  mkHex,
  ...
}: ''
  Hello this is a test

  to make a template

  and use colors as arg : ${mkRGB colors.base01}
  and use colors as arg : ${mkRGBA colors.base01}
  and use colors as arg : ${mkHex colors.base00 {alpha = true;}}


''
