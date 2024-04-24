{
  pkgs,
  nixCooker,
}: let
  inherit (nixCooker) mkTemplateContent;
in {
  theme = {
    colors = rec {
      base00 = {
        r = 253;
        g = 253;
        b = 253;
      };
      base01 = "#AABBCC";
      good = base00;
    };

    font = {
      package = pkgs.nerdfonts.override {fonts = ["Terminus"];};
      name = "Terminess Nerd Font";
    };
    templates.test = mkTemplateContent (import ./templates/test.nix);
  };
}
