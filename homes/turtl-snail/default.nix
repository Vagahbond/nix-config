{
  lib,
  nixCooker,
}: let
  inherit (nixCooker) mkTemplateContent mkRGB;
in {
  theme.colors.base00 = {
    r = 253;
    g = 253;
    b = 253;
  };
  theme.colors.base01 = "#AABBCC";
  templates.default.test = {
    content = mkTemplateContent ({colors}: "${mkRGB colors.base00}");
  };
}
