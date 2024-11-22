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

  themePackages = pkgs.callPackage ./rose-pine.nix {sddm-config = templates.sddm;};
in {
  colors = rec {
    base00 = "#faf4ed";
    base01 = "#fffaf3";
    base02 = "#f2e9de";
    base03 = "#9893a5";
    base04 = "#797593";
    base05 = "#575279";
    base06 = "#575279";
    base07 = "#cecacd";
    base08 = "#b4637a";
    base09 = "#ea9d34";
    base0A = "#d7827e";
    base0B = "#286983";
    base0C = "#56949f";
    base0D = "#907aa9";
    base0E = "#ea9d34";
    base0F = "#cecacd";
    good = base0C;
    warning = base09;
    bad = base08;
    accent = base0A;
    background = base02;
    text = base06;
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
    name = "wallpaper.jpg";
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
    package = pkgs.inconsolata-nerdfont;
    name = "Inconsolata Nerd Font";
  };

  symbolsFont = {
    # package = pkgs.nerdfonts.override {fonts = ["Terminus"];};
    # name = "Terminess Nerd Font";
  };

  inherit templates;
}
