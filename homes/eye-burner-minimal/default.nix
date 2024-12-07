{
  pkgs,
  nixCooker,
}: let
  inherit (nixCooker) mkTemplateContent;

  templates = {
    test = mkTemplateContent (import ./templates/test.nix);
    hyprland = mkTemplateContent (import ./templates/hyprland.nix);
    foot = mkTemplateContent (import ./templates/foot.nix);
    anyrunCss = mkTemplateContent (import ./templates/anyrun-css.nix);
    hyprpaper = mkTemplateContent (import ./templates/hyprpaper.nix);
    discord = mkTemplateContent (import ./templates/discord.nix);
    hyprlock = mkTemplateContent (import ./templates/hyprlock.nix);
    sddm = mkTemplateContent (import ./templates/sddm.nix);
  };

  themePackages = pkgs.callPackage ./everforest.nix {sddm-config = templates.sddm;};
in {
  radius = 0;

  colors = rec {
    base00 = "#fdf6e3";
    base01 = "#efebd4";
    base02 = "#bdc3af";
    base03 = "#bdc3af";
    base04 = "#829181";
    base05 = "#5c6a72";
    base06 = "#e0dcc7";
    base07 = "#efebd4";
    base08 = "#f85552";
    base09 = "#f57d26";
    base0A = "#ea9d34";
    base0B = "#3a94c5";
    base0C = "#36a77c";
    base0D = "#8da101";
    base0E = "#f57d26";
    base0F = "#708089";
    good = base0D;
    warning = base0A;
    bad = base08;
    accent = base0D;
    background = base01;
    text = base05;
  };

  gtkTheme = {
    name = "Rose-Pine-Light";
    package = themePackages.gtk-theme;
  };

  iconsTheme = {
    name = "rose-pine-dawn";
    package = pkgs.rose-pine-icon-theme;
  };

  qtTheme = {
    name = "Rose-Pine-Light";
    package = themePackages.gtk-theme;
  };

  wallpaper = {
    package = themePackages.wallpaper;
    name = "wallpaper.png";
  };

  cursor = {
    name = "BreezeX-RosePine-Linux";
    package = pkgs.rose-pine-cursor;
  };

  displayManagerTheme = {
    name = "rose-pine";
    package = themePackages.sddm-theme;
  };

  font = {
    package = pkgs.nerd-fonts.departure-mono;
    name = "DepartureMono Nerd Font";
  };

  symbolsFont = {
    # package = pkgs.nerdfonts.override {fonts = ["Terminus"];};
    # name = "Terminess Nerd Font";
  };

  inherit templates;
}
