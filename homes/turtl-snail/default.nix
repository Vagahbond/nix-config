{
  pkgs,
  nixCooker,
}: let
  inherit (nixCooker) mkTemplateContent;
in {
  theme = {
    colors = rec {
      base00 = "#191724";
      base01 = "#1f1d2e";
      base02 = "#26233a";
      base03 = "#6e6a86";
      base04 = "#908caa";
      base05 = "#e0def4";
      base06 = "#e0def4";
      base07 = "#524f67";
      base08 = "#eb6f92";
      base09 = "#f6c177";
      base0A = "#ebbcba";
      base0B = "#31748f";
      base0C = "#9ccfd8";
      base0D = "#c4a7e7";
      base0E = "#f6c177";
      base0F = "#524f67";
      good = base0B;
      warning = base09;
      bad = base08;
      accent = base08;
    };

    font = {
      package = pkgs.nerdfonts.override {fonts = ["Terminus"];};
      name = "Terminess Nerd Font";
    };

    templates.test = mkTemplateContent (import ./templates/test.nix);
    templates.hyprland = mkTemplateContent (import ./templates/hyprland.nix);
  };
}
