{
  lib,
  nixCooker,
}: let
  inherit (nixCooker) mkTemplateContent;
in rec {
  theme = {
    colors = {
      base00 = {
        r = 253;
        g = 253;
        b = 253;
      };
      base01 = "#AABBCC";
    };
    templates.test = mkTemplateContent theme (import ./templates/test.nix);
  };
}
