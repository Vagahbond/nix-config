{
  colors,
  mkHex,
  ...
}
: {
  accent = mkHex colors.accent;
  accent-active = mkHex colors.accent;
  accent-inactive = mkHex colors.base00;
  banner = mkHex colors.accent;
  border-active = mkHex colors.accent;
  border-inactive = mkHex colors.base02;
  header = mkHex colors.base02;
  highlight = mkHex colors.base02;
  main = mkHex colors.base01;
  notification = mkHex colors.base0B;
  notification-error = mkHex colors.base08;
  subtext = mkHex colors.base04;
  text = mkHex colors.text;
}
